# Dont forget to do thses before running and make sure you have the latest blob.csv in the same dir as the script.
# az login
# az account set -s <subID>

$storageAccountName = "cvprecordingsprodsa"
$containerName = "recordings"
$num_records = 5000

$endTime = Get-Date -Format o
$startTime = Get-Content -Path .\lastRun.txt
$filename = ".\blob.csv"
$dates = $startTime.Replace(":","-")+","+$endTime.Replace(":","-")
Add-Content -value $dates -path .\log.txt

if (-Not(Test-Path -Path $filename))
{
    Set-Content -Value "Recording,BLOB name,Room,Case,Case ID,Segment,Blob Date,CreationTime,ModifiedTime,Duration,Duration Secs,Content Length,Size MB,Size KB,BLOB_Deleted,Lease State,Lease Status,Import" -Path $filename
}

function Convert-Size {            
    [cmdletbinding()]            
    param(            
        [validateset("Bytes","KB","MB","GB","TB")]            
        [string]$From,            
        [validateset("Bytes","KB","MB","GB","TB")]            
        [string]$To,            
        [Parameter(Mandatory=$true)]            
        [double]$Value,            
        [int]$Precision = 4            
    )            
    switch($From) {            
        "Bytes" {$value = $Value }            
        "KB" {$value = $Value * 1024 }            
        "MB" {$value = $Value * 1024 * 1024}            
        "GB" {$value = $Value * 1024 * 1024 * 1024}            
        "TB" {$value = $Value * 1024 * 1024 * 1024 * 1024}            
    }            
                
    switch ($To) {            
        "Bytes" {return $value}            
        "KB" {$Value = $Value/1KB}            
        "MB" {$Value = $Value/1MB}            
        "GB" {$Value = $Value/1GB}            
        "TB" {$Value = $Value/1TB}            
                
    }            
                
    return [Math]::Round($value,$Precision,[MidPointRounding]::AwayFromZero)            
                
    }   

$continuationToken = ""

do {

    $blobObjects = ""
    if ($continuationToken -ne "")
    {
        $blobObjects = az storage blob list --account-name $storageAccountName --container-name $containerName --output json --num-results $num_records --marker $continuationToken --query "[?properties.creationTime >= '$startTime' && properties.creationTime <= '$endTime'].{Name: name, CreationTime: properties.creationTime, ContentLength: properties.contentLength, blobType: properties.blobType, lastModified: properties.lastModified, deleted: deleted, lease: properties.lease}"| ConvertFrom-Json
        $continuationToken = (az storage blob list --account-name $storageAccountName --container-name $containerName --output tsv --query "[?nextMarker!=null][nextMarker]" --num-results $num_records --show-next-marker  --marker $continuationToken)
    } 
    else
    {
        $blobObjects = az storage blob list --account-name $storageAccountName --container-name $containerName --output json --num-results $num_records --query "[?properties.creationTime >= '$startTime' && properties.creationTime <= '$endTime'].{Name: name, CreationTime: properties.creationTime, ContentLength: properties.contentLength, blobType: properties.blobType, lastModified: properties.lastModified, deleted: deleted, lease: properties.lease}"| ConvertFrom-Json 
        $continuationToken = (az storage blob list --account-name $storageAccountName --container-name $containerName --output tsv --query "[?nextMarker!=null][nextMarker]" --num-results $num_records --show-next-marker )

    } 

    foreach ($blob in $blobObjects) {
        $size_mb = Convert-Size -From Bytes -To MB -Value $($blob.ContentLength) -Precision 10
        $size_kb = Convert-Size -From Bytes -To KB -Value $($blob.ContentLength) -Precision 10

        $recording    = ""
        $file_date    = ""
        $file_time    = ""
        $file_seg     = ""
        $timeArray    = ""
        $blobDate     = ""
        $duration     = ""
        $duration_sec = "" 
        $file_room    = ""
        $file_case    = ""
        $file_case_id = ""

        try 
        {
            $creation = $($blob.CreationTime.ToUniversalTime().ToString("o"))
            $modified = $($blob.lastModified.ToUniversalTime().ToString("o"))

            #Get date data
            if( $($blob.Name) -match '(.*_(\d{4}\-\d{2}-\d{2})\-(\d{2}.\d{2}.\d{2}.\d{3})\-UTC)_(\d{1,2})\.mp4')
            {
                $recording = $Matches[1]
                $file_date = $Matches[2]
                $file_time = $Matches[3].Replace(".",":")
                $file_seg  = $Matches[4]
                $timeArray = $file_time -split(":") 
                $blobDate  = $file_date+"T"+$timeArray[0]+":"+$timeArray[1]+":"+$timeArray[2]+".0000000Z"
                $duration  = (New-TimeSpan -Start $blobDate -End $creation)
                $duration_sec  = $duration.TotalSeconds

                # Get case data
                if( $($blob.Name) -match '(.*)\/((\w{4})\-.*)_(\d{4}\-\d{2}-\d{2})\-(\d{2}.\d{2}.\d{2}.\d{3})\-UTC_(\d{1,2})\.mp4') 
                {    
                    
                    $file_room    = $Matches[1]
                    $file_case    = $Matches[2]
                    $file_case_id = $Matches[3]
                    
                    Add-Content -Value "$recording,$($blob.Name),$file_room,$file_case,$file_case_id,$file_seg,$blobDate,$creation,$modified,$duration,$duration_sec,$($blob.ContentLength),$size_mb,$size_kb,$($blob.deleted),$($blob.lease.state),$($blob.lease.status)," -Path $fileName
                }
                else 
                {
                    Add-Content -Value "$recording,$($blob.Name),,,,$file_seg,$blobDate,$creation,$modified,$duration,$duration_sec,$($blob.ContentLength),$size_mb,$size_kb,$($blob.deleted),$($blob.lease.state),$($blob.lease.status),Case Regex Error" -Path $fileName
                }
            }
            else
            {
                Add-Content -Value ",$($blob.Name),,,,,,$creation,$modified,,,$($blob.ContentLength),$size_mb,$size_kb,$($blob.deleted),$($blob.lease.state),$($blob.lease.status),Date Regex Error" -Path $fileName
            }
        }
        catch 
        {
            Add-Content -Value ",$($blob.Name),,,,,,$creation,$modified,,,$($blob.ContentLength),$size_mb,$size_kb,$($blob.deleted),$($blob.lease.state),$($blob.lease.status),Import Regex Error" -Path $fileName
        }
    }

} while ($continuationToken -ne $null)

Set-Content -Value $endTime -Path .\lastRun.txt