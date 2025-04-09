Param (
    [Parameter(Mandatory)]
    [ValidateSet("SBOX","PROD","STG")]
    [string]$env,
    [string]$locName="uksouth",
    [string]$pubName="wowza",
    [string]$offerName="wowzastreamingengine",
    [string]$skuName="linux-paid-4-8"

)

$rgName="CVP-RECORDINGS-$($env)-RG"
$vmName="cvp-recordings-$($env)-vm1".ToLower()
$subName="DTS-SHAREDSERVICES-$($env)"

function check-marketplace {
    Connect-AzAccount -Subscription $subName
    Write-Host "Subscription set to $($subName)"
    
    $vm = Get-AzVm -ResourceGroupName $rgName -Name $vmName
    $currentVersion = $vm.StorageProfile.imageReference.version
    $getLatest = Get-AzVMImage -Location $locName -PublisherName $pubName -Offer $offerName -Sku $skuName -Version latest
    $latestVersion = $getLatest.Version
    
    if ($currentVersion -lt $latestVersion) {
        Throw "Newer version $($latestVersion) available"
    }
    else {
        Write-Host "Current version $($currentVersion) is same as latest version $($latestVersion)."
    }
}

check-marketplace
