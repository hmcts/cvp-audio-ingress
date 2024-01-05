Param (
    [Parameter(Mandatory)]
    [ValidateSet("SBOX","PROD","STG")]
    [string]$env    
)

$env_string = switch ($env) {
    "SBOX" { ".sandbox" }
    "STG"  { ".aat" }
    "PROD"  { "" }
    Default {""}
}

$hostName = "cvp-recording$($env_string).platform.hmcts.net"
$sub = "DTS-SHAREDSERVICES-$($env)"
$is_error = $false
$sampleFileSource="https://filesamples.com/samples/video/mp4/sample_640x360.mp4"  
$currentPath = Get-Location
$downloadPath = "$currentPath/audio"

function test-stream {
    param (
        $hostname,
        $port
    )

    $containerName = "recordings"
    $accountName = "cvprecordings$($env)sa".ToLower()
    $wait = 2
    $n = 2
    $wowzaApplication = "audiostream1"
    $fileName= "testStream_$(Get-Date -Format "yyyyMMddHHmmss")"

    ##############################
    ## Check connection to stream is open

    Write-Host "`n#### Testing stream to $hostname on port: $port" -ForegroundColor Blue
    $i = 1
    Do {
        Write-Host "... [$i/$n] Checking port $port on $hostname" -ForegroundColor Blue
        $conn = (Test-Connection -ComputerName $hostname -TcpPort $port)
        if ($conn) {
            Write-Host "... Connection successful!" -ForegroundColor Green
        } else {
            Write-Host "... Connection failed, trying again in $wait second(s)" -ForegroundColor Cyan
            Start-Sleep -Seconds $wait
            $i ++
        }
    } Until ($conn -or ($i -ge $n))

    if(!($conn)) {
        Write-Error "FAILED - Connection could not be made."
        return $false
    } else {
        # Run FFMPEG TEST
        Write-Host "... running a stream to $hostname..."  -ForegroundColor Blue
        $ffmpeg_url="rtmps://$($hostname):$($port)/$wowzaApplication/$fileName"

        Write-Host "URL: $ffmpeg_url"  -ForegroundColor Blue
        Write-Host "File: $audioFile"  -ForegroundColor Blue
        ffmpeg -re -i $audioFile -c copy -f flv "$ffmpeg_url flashver=FMLE/3.0\20(compatible;\20FMSc/1.0) live=true pubUser=wowza title=$fileName" -loglevel warning
        
        ## Check BLOB is available in SA
        $blobSearch = "$wowzaApplication/$fileName"
        Write-Host "... searching for $blobSearch in Container: $containerName in Storage Account: $accountName" -ForegroundColor Blue
        $blobs = az storage blob list -c $containerName --prefix $blobSearch --account-name $accountName --only-show-errors -o json | ConvertFrom-Json
        if (!$?) {
            Write-Error "Failed to connect to SA"
            return $false
        } else {
            if ($blobs.Length -lt 1) {
                Write-Error "FAILED - File could not be found."
                return $false
            }
            else {
                $recording = $blobs[0];
                if ($recording.properties.contentLength -lt 1) {
                    Write-Error "FAILED - Recording size is 0"
                    return $false
                } 
                else {
                    Write-Host "... file found" -ForegroundColor Green
                    return $true
                }
            }
        }

    }
}

Write-Host "`n# Running tests on $env" -ForegroundColor Yellow

## Set sub
Write-Host "`n# Setting Subscription: $sub" -ForegroundColor Yellow
az account set -n $sub
if (!$?) {
    Write-Error "Failed to set sub"
    $is_error = $true
} else {
    write-host "... subscription set" -ForegroundColor Green
}

## Check VM are all running
if(!($is_error)){
    Write-Host "`n# Checking VM power status" -ForegroundColor Yellow
    $vms = az vm list -d -g cvp-recordings-$($env)-rg -o json | ConvertFrom-Json
    foreach($vm in $vms) {
        if ($vm.powerState -ne "VM Running") {
            $is_error = $true
            Write-Error "$($vm.name) is in state: '$($vm.powerState)'"
        } else {
            Write-Host "... $($vm.name) is running" -ForegroundColor Green
        }
    }
}

## Get LB IP
if(!($is_error)){
    Write-Host "`n# Getting LB IP address" -ForegroundColor Yellow
    $lb = az network lb frontend-ip show --lb-name cvp-recordings-$env-lb -n PrivateIPAddress -g cvp-recordings-$env-rg  -o json | ConvertFrom-Json
    if (!$?) {
        Write-Error "Failed to get LB IP address"
        $is_error = $true
    } else {
        $ip = $lb.privateIpAddress
        Write-Host "... load Balancer IP is: $ip" -ForegroundColor Green
    }
}

## TEST DNS
if(!($is_error)){
    Write-Host "`n# Testing DNS" -ForegroundColor Yellow
    $dnsIP = (Resolve-DnsName -name $hostName).IPAddress
    Write-Host "... DNS resolves to: $dnsIP"
    if($dnsIP -eq $ip){
        Write-Host "... DNS IP ($dnsIP) matches LB IP ($ip)" -ForegroundColor Green
    } else {
        $is_error = $true
        Write-Error "DNS IP ($dnsIP) is different LB IP ($ip). Are you connected to the VPN?"
    }
}

## Set up Streaming tests
if(!($is_error)){
    Write-Host "`n# Getting sample file to stream..." -ForegroundColor Yellow
    if ((Test-Path -Path $downloadPath) -eq $false) {
        mkdir $downloadPath 
    }

    $audioFile = "$downloadPath/audio-example.mp4"
    if ((Test-Path -Path $audioFile) -eq $false) {
        Invoke-WebRequest -Uri $sampleFileSource -OutFile $audioFile 
    }
}

## Test Stream LB
if(!($is_error)){
    Write-Host "`n# Testing stream to LB" -ForegroundColor Yellow
    $test = test-stream -port 443 -hostname $hostName
    if (!($test)) {
        $is_error = $true
        Write-Error "Stream failed"
    } 
}

## Test Stream Direct
if(!($is_error)){
    Write-Host "`n# Testing stream via NAT" -ForegroundColor Yellow
    $nat = 443
    for ($i=1; $i -le $($vms.Count); $i++)
    {
        $newPort = $nat + $i
        $test = test-stream -port $newPort -hostname $hostName
        if (!($test)) {
            $is_error = $true
            Write-Error "Stream failed"
        } 
    }
}

## Check WSEM
if(!($is_error)){
    Write-Host "`n# Checking WSEM is running" -ForegroundColor Yellow
    $r = (Invoke-WebRequest -SkipCertificateCheck -uri "https://$($hostName):8090").StatusCode
    Write-Host "... https://$($hostName):8090"
    if ($r -eq 200) {
        Write-Host "... WSEM running" -ForegroundColor Green
    } else {
        $is_error = $true
        Write-Error "WSEM not running"
    }
}

## Test Stream Direct
if(!($is_error)){
    Write-Host "`n# Testing WSEM is running via NAT" -ForegroundColor Yellow
    $nat = 8090
    for ($i=1; $i -le $($vms.Count); $i++)
    {
        $newPort = $nat + $i
        $r = (Invoke-WebRequest -SkipCertificateCheck -uri "https://$($hostName):$($newPort)").StatusCode
        Write-Host "... https://$($hostName):$($newPort)"
        if ($r -eq 200) {
            Write-Host "... WSEM running" -ForegroundColor Green
        } else {
            $is_error = $true
            Write-Error "WSEM not running"
        }
    }
}

if(!($is_error)){
    Write-Host "`n## ALL TESTS PASSED ##" -ForegroundColor Green
} else {
    Write-Host "`n## SOME TESTS FAILED ##" -ForegroundColor Red
}