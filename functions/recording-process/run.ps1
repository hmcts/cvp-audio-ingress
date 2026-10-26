param($eventGridEvent, $TriggerMetadata)

$ErrorActionPreference = 'Stop'

try {
    # Get the blob URL from the Event Grid event
    $uri = [System.Uri]$eventGridEvent.data.url
    $pathParts = $uri.AbsolutePath.TrimStart('/').Split('/', 2)

    $container = $pathParts[0]
    $blobName = [System.Uri]::UnescapeDataString($pathParts[1])
    $fileName = [System.IO.Path]::GetFileName($blobName)

    Write-Host "Processing blob: $fileName"

    # Parse the filename
    $pattern = '^[^-]+-(?<Courtroom>\d+)-(?<Courthouse>[^_]+)_(?<Date>\d{4}-\d{2}-\d{2})-(?<Time>\d{2}\.\d{2}\.\d{2})(?:\.\d+)?-(?<TimeZone>[A-Za-z]+)\.mp4$'

    if ($fileName -notmatch $pattern) {
        Write-Host "Filename does not match the expected format. Skipping."
        return
    }

    $courtroom = [int]$Matches.Courtroom
    $courthouse = $Matches.Courthouse
    $date = $Matches.Date
    $time = $Matches.Time
    $timeZone = $Matches.TimeZone

    # This initial version supports UTC filenames only
    if ($timeZone -ne 'UTC') {
        throw "Unsupported time zone in filename: $timeZone"
    }

    # Convert the filename timestamp to standard ISO 8601 UTC
    $timeForParsing = $time.Replace('.', ':')
    $startTime = [DateTime]::ParseExact(
        "$date $timeForParsing",
        'yyyy-MM-dd HH:mm:ss',
        [Globalization.CultureInfo]::InvariantCulture,
        [Globalization.DateTimeStyles]::AssumeUniversal -bor
        [Globalization.DateTimeStyles]::AdjustToUniversal
    ).ToString("yyyy-MM-dd'T'HH:mm:ss'Z'")

    Write-Host "Courtroom: $courtroom"
    Write-Host "Courthouse: $courthouse"
    Write-Host "StartTime: $startTime"

    # Authenticate using the Function App's managed identity
    Connect-AzAccount -Identity | Out-Null

    $accountName = $uri.Host.Split('.')[0]
    $context = New-AzStorageContext `
        -StorageAccountName $accountName `
        -UseConnectedAccount

    # Add metadata to the existing blob
    $metadata = @{
        Courtroom  = [string]$courtroom
        Courthouse = $courthouse
        StartTime  = $startTime
    }

    Set-AzStorageBlobMetadata `
        -Container $container `
        -Blob $blobName `
        -Metadata $metadata `
        -Context $context `
        -ErrorAction Stop | Out-Null

    Write-Host "Successfully updated metadata for $fileName"
}
catch {
    Write-Error "Failed to process recording: $($_.Exception.Message)"
    throw
}

# Make sure to pass hashtables to Out-String so they're logged correctly
$eventGridEvent | Out-String | Write-Host
