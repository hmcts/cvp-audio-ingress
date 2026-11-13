using System.Buffers.Binary;
using System.Globalization;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;

using Azure;
using Azure.Identity;
using Azure.Messaging.EventGrid;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;

using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

public class ProcessRecording
{
    private readonly ILogger<ProcessRecording> _logger;

    // Reuse the credential between invocations.
    private static readonly DefaultAzureCredential Credential = new(
        new DefaultAzureCredentialOptions
        {
            ManagedIdentityClientId = string.IsNullOrWhiteSpace(Environment.GetEnvironmentVariable("AZURE_CLIENT_ID"))
                ? null
                : Environment.GetEnvironmentVariable("AZURE_CLIENT_ID")
        });

    private const string FilenamePattern =
        @"^[^-]+-(?<Courtroom>\d+)-(?<Courthouse>[^_]+)_" +
        @"(?<Date>\d{4}-\d{2}-\d{2})-" +
        @"(?<Time>\d{2}\.\d{2}\.\d{2})" +
        @"(?:\.(?<Fraction>\d{1,9}))?-UTC\.mp4$";

    public ProcessRecording(ILogger<ProcessRecording> logger)
    {
        _logger = logger;
    }

    [Function(nameof(ProcessRecording))]
    public async Task Run(
        [EventGridTrigger] EventGridEvent eventGridEvent,
        CancellationToken cancellationToken)
    {
        if (eventGridEvent.EventType != "Microsoft.Storage.BlobCreated")
        {
            return;
        }

        JsonElement data = eventGridEvent.Data.ToObjectFromJson<JsonElement>();
        if (!data.TryGetProperty("url", out JsonElement urlElement) ||
            string.IsNullOrWhiteSpace(urlElement.GetString()))
        {
            throw new InvalidOperationException("BlobCreated event has no blob URL.");
        }

        var source = new BlobClient(new Uri(urlElement.GetString()!), Credential);

        if (!source.Name.EndsWith(".mp4", StringComparison.OrdinalIgnoreCase))
        {
            return;
        }

        string originalFileName = Path.GetFileName(source.Name);
        Match match = Regex.Match(
            originalFileName,
            FilenamePattern,
            RegexOptions.IgnoreCase | RegexOptions.CultureInvariant);

        // Organised copies have a different filename and will be ignored.
        // This prevents the BlobCreated event from triggering a copy loop.
        if (!match.Success)
        {
            _logger.LogInformation("Skipping non-original recording name: {Name}", source.Name);
            return;
        }

        string courtroom = int.Parse(
            match.Groups["Courtroom"].Value,
            CultureInfo.InvariantCulture).ToString(CultureInfo.InvariantCulture);

        string courthouse = match.Groups["Courthouse"].Value;
        DateTimeOffset startUtc = ParseStartUtc(match);

        BlobProperties sourceProperties;
        try
        {
            sourceProperties = (await source.GetPropertiesAsync(
                cancellationToken: cancellationToken)).Value;
        }
        catch (RequestFailedException ex) when (ex.Status == 404)
        {
            // A duplicate BlobCreated event can arrive after another invocation moved it.
            _logger.LogInformation("Source no longer exists; skipping {Name}", source.Name);
            return;
        }

        if (sourceProperties.ContentLength <= 0)
        {
            throw new InvalidDataException($"Zero-length recording: {source.Name}");
        }

        // Reads ONLY MP4 box headers and the small movie-header duration field.
        // Does not download media samples or need ffprobe.
        TimeSpan duration = await ReadMp4DurationAsync(
            source,
            sourceProperties.ContentLength,
            sourceProperties.ETag,
            cancellationToken);

        DateTimeOffset endUtc = startUtc.Add(duration);

        string startMetadata = FormatMetadataTime(startUtc);
        string endMetadata = FormatMetadataTime(endUtc);

        string newFileName = $"{Guid.NewGuid():D}.mp4";

        // This uses COURTHOUSE as in the supplied example.
        // For a courtroom folder instead, replace courthouse with courtroom.
        string newBlobName = string.Join("/",
            startUtc.Year.ToString(CultureInfo.InvariantCulture),
            startUtc.Month.ToString(CultureInfo.InvariantCulture),
            startUtc.Day.ToString(CultureInfo.InvariantCulture),
            courthouse,
            newFileName);

        string destinationStorageUrl =
            Environment.GetEnvironmentVariable("CRIME_DESTINATION_STORAGE_URL")
            ?? throw new InvalidOperationException("CRIME_DESTINATION_STORAGE_URL is not configured.");
        string destinationContainerName =
            Environment.GetEnvironmentVariable("CRIME_DESTINATION_CONTAINER")
            ?? throw new InvalidOperationException("CRIME_DESTINATION_CONTAINER is not configured.");

        var destinationService = new BlobServiceClient(new Uri(destinationStorageUrl), Credential);
        var destinationContainer = destinationService.GetBlobContainerClient(destinationContainerName);
        var destination = destinationContainer.GetBlobClient(newBlobName);

        var metadata = new Dictionary<string, string>(
            sourceProperties.Metadata ?? new Dictionary<string, string>(),
            StringComparer.OrdinalIgnoreCase)
        {
            ["originalFilename"] = source.Name,
            ["Courtroom"] = courtroom,
            ["Courthouse"] = courthouse,
            ["recordingStartTimeUtc"] = startMetadata,
            ["recordingEndTimeUtc"] = endMetadata,
            ["checksumAlgorithm"] = "MD5",
            // Allows retries to identify the exact source version copied.
            ["processedSourceETag"] = sourceProperties.ETag.ToString()
        };

        if (sourceProperties.ContentHash is { Length: > 0 } hash)
        {
            metadata["checksum"] = Convert.ToBase64String(hash);
        }
        else
        {
            metadata.Remove("checksum");
            _logger.LogWarning("No Content-MD5 on {Name}; checksum omitted.", source.Name);
        }

        if (string.Equals(Environment.GetEnvironmentVariable("RECORDING_DRY_RUN"),
                "true", StringComparison.OrdinalIgnoreCase))
        {
            _logger.LogInformation(
                "DRY RUN: {Source} -> {Destination}; duration {DurationSeconds}s; end {End}",
                source.Uri, destination.Uri, duration.TotalSeconds, endMetadata);
            return;
        }

        try
        {
            var download = await source.DownloadStreamingAsync(
                new BlobDownloadOptions
                {
                    Conditions = new BlobRequestConditions { IfMatch = sourceProperties.ETag }
                },
                cancellationToken);

            await using Stream content = download.Value.Content;
            await destination.UploadAsync(
                content,
                new BlobUploadOptions
                {
                    HttpHeaders = new BlobHttpHeaders
                    {
                        CacheControl = sourceProperties.CacheControl,
                        ContentDisposition = sourceProperties.ContentDisposition,
                        ContentEncoding = sourceProperties.ContentEncoding,
                        ContentLanguage = sourceProperties.ContentLanguage,
                        ContentType = sourceProperties.ContentType,
                        ContentHash = sourceProperties.ContentHash
                    },
                    Metadata = metadata,
                    Conditions = new BlobRequestConditions { IfNoneMatch = ETag.All }
                },
                cancellationToken);
        }
        catch (RequestFailedException ex) when (ex.Status == 412)
        {
            // A retry may find that the destination was already created.
            // Verify it below; never overwrite it or blindly delete the source.
            _logger.LogWarning(
                "Copy precondition failed for {Destination}; checking existing destination.",
                newBlobName);
        }

        BlobProperties destinationProperties = (await destination.GetPropertiesAsync(
            cancellationToken: cancellationToken)).Value;

        var copiedMetadata = new Dictionary<string, string>(
            destinationProperties.Metadata, StringComparer.OrdinalIgnoreCase);

        if (destinationProperties.ContentLength != sourceProperties.ContentLength ||
            !copiedMetadata.TryGetValue("processedSourceETag", out string? copiedETag) ||
            copiedETag != sourceProperties.ETag.ToString() ||
            !copiedMetadata.TryGetValue("recordingEndTimeUtc", out string? copiedEnd) ||
            copiedEnd != endMetadata ||
            (sourceProperties.ContentHash is { Length: > 0 } originalHash &&
             (destinationProperties.ContentHash == null ||
              !destinationProperties.ContentHash.AsSpan().SequenceEqual(originalHash))))
        {
            throw new InvalidOperationException(
                $"Destination verification failed for {newBlobName}; source has NOT been deleted.");
        }

        // Protect against deleting a source that was replaced after the copy.
        await source.DeleteAsync(
            conditions: new BlobRequestConditions { IfMatch = sourceProperties.ETag },
            cancellationToken: cancellationToken);

        _logger.LogInformation(
            "Organised recording {Source} -> {Destination}. Start: {Start}; End: {End}; DurationSeconds: {Duration}",
            source.Uri, destination.Uri, startMetadata, endMetadata, duration.TotalSeconds);
    }

    private static DateTimeOffset ParseStartUtc(Match match)
    {
        DateTimeOffset start = DateTimeOffset.ParseExact(
            $"{match.Groups["Date"].Value} {match.Groups["Time"].Value}",
            "yyyy-MM-dd HH.mm.ss",
            CultureInfo.InvariantCulture,
            DateTimeStyles.AssumeUniversal | DateTimeStyles.AdjustToUniversal);

        string fraction = match.Groups["Fraction"].Value;
        if (fraction.Length > 0)
        {
            // A DateTime tick is 1/10,000,000 second; retain up to 7 digits.
            string ticksText = fraction.PadRight(7, '0')[..7];
            start = start.AddTicks(long.Parse(ticksText, CultureInfo.InvariantCulture));
        }

        return start;
    }

    private static string FormatMetadataTime(DateTimeOffset time) =>
        time.UtcDateTime.ToString("yyyy-MM-dd'T'HH:mm:ss'Z'", CultureInfo.InvariantCulture);

    private readonly record struct Mp4Box(string Type, long DataStart, long End);

    private static async Task<TimeSpan> ReadMp4DurationAsync(
        BlobClient blob, long fileLength, ETag etag, CancellationToken ct)
    {
        long offset = 0;
        int inspected = 0;

        while (offset < fileLength && inspected++ < 256)
        {
            Mp4Box box = await ReadBoxAsync(blob, offset, fileLength, etag, ct);
            if (box.Type == "moov")
            {
                long childOffset = box.DataStart;
                int children = 0;
                while (childOffset < box.End && children++ < 256)
                {
                    Mp4Box child = await ReadBoxAsync(blob, childOffset, box.End, etag, ct);
                    if (child.Type == "mvhd")
                    {
                        return await ReadMovieHeaderDurationAsync(blob, child, etag, ct);
                    }
                    childOffset = child.End;
                }
                throw new InvalidDataException("MP4 moov box contains no readable mvhd box.");
            }
            // Skip the large mdat payload by its declared byte length, not by downloading it.
            offset = box.End;
        }

        throw new InvalidDataException("MP4 moov box not found or box count limit exceeded.");
    }

    private static async Task<Mp4Box> ReadBoxAsync(
        BlobClient blob, long position, long parentEnd, ETag etag, CancellationToken ct)
    {
        long remaining = parentEnd - position;
        if (remaining < 8)
        {
            throw new InvalidDataException($"Truncated MP4 box at byte {position}.");
        }

        byte[] header = await ReadRangeAsync(
            blob, position, (int)Math.Min(16, remaining), etag, ct);

        uint size32 = BinaryPrimitives.ReadUInt32BigEndian(header.AsSpan(0, 4));
        string type = Encoding.ASCII.GetString(header, 4, 4);
        int headerLength = size32 == 1 ? 16 : 8;
        if (header.Length < headerLength)
        {
            throw new InvalidDataException("Truncated 64-bit MP4 box header.");
        }

        ulong boxSize = size32 switch
        {
            0 => (ulong)remaining, // Size 0: extends to the end of the parent.
            1 => BinaryPrimitives.ReadUInt64BigEndian(header.AsSpan(8, 8)),
            _ => size32
        };

        if (boxSize < (ulong)headerLength || boxSize > (ulong)remaining)
        {
            throw new InvalidDataException($"Invalid {type} box size at byte {position}.");
        }

        return new Mp4Box(type, position + headerLength, position + (long)boxSize);
    }

    private static async Task<TimeSpan> ReadMovieHeaderDurationAsync(
        BlobClient blob, Mp4Box box, ETag etag, CancellationToken ct)
    {
        long payloadLength = box.End - box.DataStart;
        if (payloadLength < 20)
        {
            throw new InvalidDataException("MP4 mvhd box is too short.");
        }

        byte[] header = await ReadRangeAsync(
            blob, box.DataStart, (int)Math.Min(32, payloadLength), etag, ct);

        byte version = header[0];
        uint timescale;
        ulong durationUnits;

        if (version == 0)
        {
            timescale = BinaryPrimitives.ReadUInt32BigEndian(header.AsSpan(12, 4));
            durationUnits = BinaryPrimitives.ReadUInt32BigEndian(header.AsSpan(16, 4));
            if (durationUnits == uint.MaxValue)
                throw new InvalidDataException("MP4 duration is unspecified.");
        }
        else if (version == 1 && header.Length >= 32)
        {
            timescale = BinaryPrimitives.ReadUInt32BigEndian(header.AsSpan(20, 4));
            durationUnits = BinaryPrimitives.ReadUInt64BigEndian(header.AsSpan(24, 8));
            if (durationUnits == ulong.MaxValue)
                throw new InvalidDataException("MP4 duration is unspecified.");
        }
        else
        {
            throw new InvalidDataException("Unsupported or incomplete MP4 mvhd version.");
        }

        if (timescale == 0 || durationUnits == 0)
        {
            // Fragmented MP4 may have an unknown duration in mvhd; don't guess.
            throw new InvalidDataException("MP4 movie duration or timescale is zero.");
        }

        double seconds = (double)durationUnits / timescale;
        if (!double.IsFinite(seconds) || seconds > TimeSpan.MaxValue.TotalSeconds)
        {
            throw new InvalidDataException("Invalid MP4 movie duration.");
        }

        return TimeSpan.FromSeconds(seconds);
    }

    private static async Task<byte[]> ReadRangeAsync(
        BlobClient blob, long offset, int bytes, ETag etag, CancellationToken ct)
    {
        var response = await blob.DownloadStreamingAsync(
            new BlobDownloadOptions
            {
                Range = new HttpRange(offset, bytes),
                Conditions = new BlobRequestConditions { IfMatch = etag }
            },
            ct);

        await using Stream stream = response.Value.Content;
        byte[] result = new byte[bytes];
        await stream.ReadExactlyAsync(result.AsMemory(), ct);
        return result;
    }
}
