# Make sure you have installed ffmpeg before running

$env = "stg"
$ports = ("443") #443 for LB, allows additional ports to test VM vis NAT rules


$containerName = "recordings"
$accountName = "cvprecordings$($env)sa"
$wait = 2
$n = 2
$wowzaApplication = "audiostream1"
$fileName= "testStream_$(Get-Date -Format "yyyyMMddHHmmss")"
$sampleFileSource="https://filesamples.com/samples/video/mp4/sample_640x360.mp4"  
$currentPath = Get-Location
$downloadPath = "$currentPath/audio"

##############################
## Get LB IP

$lb = az network lb frontend-ip show --lb-name cvp-recordings-$env-lb -n PrivateIPAddress -g cvp-recordings-$env-rg  -o json | ConvertFrom-Json
$ip = $lb.privateIpAddress
Write-Host "Load Balancer IP is: $ip"

##############################
## Get test file

Write-Host "Getting sample file to stream..."
if ((Test-Path -Path $downloadPath) -eq $false) {
  mkdir $downloadPath 
}

$audioFile = "$downloadPath/audio-example.mp4"

if ((Test-Path -Path $audioFile) -eq $false) {
  Invoke-WebRequest -Uri $sampleFileSource -OutFile $audioFile 
}
$r = @()

foreach ($port in $ports){

    ##############################
    ## Check connection to stream is open
    Write-Host "##### Testing stream to $ip on port: $port"
    $i = 1
    Do {
    Write-Host "[$i/$n] Checking port $port on $ip"
    $conn = (Test-Connection -ComputerName $ip -TcpPort $port)
    if ($conn) {
        Write-Host "Connection successful!"
    } else {
        Write-Host "Connection failed, trying again in $wait second(s)"
        Start-Sleep -Seconds $wait
        $i ++
    }
    } Until ($conn -or ($i -ge $n))

    if(!($conn)) {
    Write-Host "FAILED - Connection could not be made."
    $r += "[$($ip):$port] FAILED - Connection could not be made."
    } else {
        # Run FFMPEG TEST
        Write-Host "Running a stream to $ip..."
        $ffmpeg_url="rtmps://$($ip):443/$wowzaApplication/$fileName"

        Write-Host "URL: $ffmpeg_url"
        Write-Host "File: $audioFile"
        ffmpeg -re -i $audioFile -c copy -f flv "$ffmpeg_url flashver=FMLE/3.0\20(compatible;\20FMSc/1.0) live=true pubUser=wowza title=$fileName" -loglevel verbose
        
        ####################
        ## Check BLOB is available in SA
        $blobSearch = "$wowzaApplication/$fileName"
        Write-Host "Searching for $blobSearch in Container: $containerName in Storage Account: $accountName"
        
        $blobs = az storage blob list -c $containerName --prefix $blobSearch --account-name $accountName --only-show-errors -o json | ConvertFrom-Json
        
        if ($blobs.Length -lt 1) {
            Write-Host "FAILED - File could not be found."
            $r += "[$($ip):$port] FAILED - File could not be found."
        }
        else {
            $recording = $blobs[0];
            if ($recording.properties.contentLength -lt 1) {
                Write-Host "FAILED - Recording size is 0"
                $r += "[$($ip):$port] FAILED - Recording size is 0"
            } 
            else {
                Write-Host "OK - File found"
                $r += "[$($ip):$port] OK - File found"
            }
        }

    }
}
Write-Host "####################################"
Write-Host "############ RESULTS ###############"
Write-Host "####################################"
$r
Write-Host "####################################"
