using System.Globalization;
using System.Text.Json;
using System.Text.RegularExpressions;

using Azure.Identity;
using Azure.Messaging.EventGrid;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;

using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

public class ProcessRecording
{
    private readonly ILogger<ProcessRecording> _logger;

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
            _logger.LogInformation(
                "Ignoring event type {EventType}",
                eventGridEvent.EventType);
            return;
        }

        JsonElement data = eventGridEvent.Data.ToObjectFromJson<JsonElement>();

        if (!data.TryGetProperty("url", out JsonElement urlElement))
        {
            throw new InvalidOperationException(
                "The Event Grid event does not contain a blob URL.");
        }

        string blobUrl = urlElement.GetString()
            ?? throw new InvalidOperationException(
                "The blob URL in the Event Grid event is empty.");

        string? managedIdentityClientId =
            Environment.GetEnvironmentVariable("AZURE_CLIENT_ID");

        var credential = new DefaultAzureCredential(
            new DefaultAzureCredentialOptions
            {
                ManagedIdentityClientId = string.IsNullOrWhiteSpace(managedIdentityClientId)
                    ? null
                    : managedIdentityClientId
            });

        var blob = new BlobClient(new Uri(blobUrl), credential);

        // Only process MP4 recordings.
        if (!blob.Name.EndsWith(".mp4", StringComparison.OrdinalIgnoreCase))
        {
            _logger.LogInformation(
                "Ignoring non-MP4 blob {BlobName}",
                blob.Name);
            return;
        }

        BlobProperties properties = (await blob.GetPropertiesAsync(
            cancellationToken: cancellationToken)).Value;

        if (properties.ContentLength <= 0)
        {
            throw new InvalidOperationException(
                $"Blob '{blob.Name}' has no content or has a zero-byte length.");
        }

        string fileName = Path.GetFileName(blob.Name);

        // Expected example:
        // <prefix>-<courtroom>-<courthouse>_2026-07-28-10.45.21-UTC.mp4
        // Optional fractional seconds are accepted before -UTC.mp4.
        const string filenamePattern =
            @"^[^-]+-(?<Courtroom>\d+)-(?<Courthouse>[^_]+)_" +
            @"(?<Date>\d{4}-\d{2}-\d{2})-" +
            @"(?<Time>\d{2}\.\d{2}\.\d{2})" +
            @"(?:\.(?<Milliseconds>\d+))?-UTC\.mp4$";

        Match match = Regex.Match(
            fileName,
            filenamePattern,
            RegexOptions.IgnoreCase | RegexOptions.CultureInvariant);

        if (!match.Success)
        {
            _logger.LogWarning(
                "Filename does not match the expected recording format; metadata was not changed. Blob: {BlobName}",
                blob.Name);
            return;
        }

        string courtroom = int.Parse(
            match.Groups["Courtroom"].Value,
            CultureInfo.InvariantCulture).ToString(CultureInfo.InvariantCulture);

        string courthouse = match.Groups["Courthouse"].Value;

        DateTimeOffset recordingStartTimeUtc;
        try
        {
            recordingStartTimeUtc = DateTimeOffset.ParseExact(
                $"{match.Groups["Date"].Value} {match.Groups["Time"].Value}",
                "yyyy-MM-dd HH.mm.ss",
                CultureInfo.InvariantCulture,
                DateTimeStyles.AssumeUniversal).ToUniversalTime();
        }
        catch (FormatException ex)
        {
            _logger.LogWarning(
                ex,
                "Could not parse recording start time from blob name {BlobName}; metadata was not changed.",
                blob.Name);
            return;
        }

        string startTimeText = recordingStartTimeUtc.ToString(
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            CultureInfo.InvariantCulture);

        // Preserve existing metadata and update the requested fields.
        var metadata = new Dictionary<string, string>(
            properties.Metadata ?? new Dictionary<string, string>(),
            StringComparer.OrdinalIgnoreCase);

        metadata["originalFilename"] = blob.Name;
        metadata["Courtroom"] = courtroom;
        metadata["Courthouse"] = courthouse;
        metadata["recordingStartTimeUtc"] = startTimeText;

        // End-time calculation is intentionally disabled for now.
        // The metadata key is written with a blank value.
        metadata["recordingEndTimeUtc"] = string.Empty;

        metadata["checksumAlgorithm"] = "MD5";

        // Copy the blob's existing Content-MD5 property; do not calculate a checksum.
        if (properties.ContentHash is { Length: > 0 } contentHash)
        {
            metadata["checksum"] = Convert.ToBase64String(contentHash);
        }
        else
        {
            // Remove any stale checksum value if Content-MD5 is not present.
            metadata.Remove("checksum");

            _logger.LogWarning(
                "Blob {BlobName} has no Content-MD5 property. The checksum metadata will be omitted; no checksum will be calculated.",
                blob.Name);
        }

        await blob.SetMetadataAsync(
            metadata,
            cancellationToken: cancellationToken);

        _logger.LogInformation(
            "Updated metadata for {BlobName}. Courtroom: {Courtroom}; Courthouse: {Courthouse}; Start: {StartTime}; End time left blank; MD5 available: {HasMd5}",
            blob.Name,
            courtroom,
            courthouse,
            startTimeText,
            properties.ContentHash is { Length: > 0 });
    }
}
