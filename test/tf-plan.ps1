
$env="sbox"
$subscriptionName="DTS-SHAREDSERVICES-"+$env.ToUpper()
az account set -s $subscriptionName

## set override
$overrideContent = "terraform {
    backend `"azurerm`" {
      resource_group_name  = `"cvp-sharedinfra-$env`"
      storage_account_name = `"cvp"+$env+"terraform`"
      container_name       = `"terraform-state`"
      key                  = `"UK South/$env/application/01-cvp-audio-ingress/terraform.tfstate`"
    }
  }
"

$rootPath = split-path -parent $MyInvocation.MyCommand.Definition;
Set-Location "$rootPath/.."
$fileName = "override.tf"
if (!(Test-Path $fileName))
{
    New-Item -path $overridePath -name $fileName -type "file" -value $overrideContent
}
else
{
    Clear-Content $fileName
    Add-Content -path $fileName -value $overrideContent
}

## Test Variable
$builtFrom="hmcts/cvp-audio-ingress"

$global:ws_sub_name="";
Get-Content "pipeline/variables/variables-$env.yaml" | Foreach-Object{
  $var = $_.Split(':')
  $var_name = $var[0]
  #write-host "got $var_name"
  if ($var_name -like "*ws_sub_name*"){
    $sub_name = $var[1].Trim().Replace("`"","")
    write-host "Got Subscription Name - $sub_name"
    $global:ws_sub_name = $sub_name
  }
}

$kvName="cvp-$env-kv"
$certPath="test/cert.pem"
if (Test-Path $certPath){
  Remove-Item $certPath
}
$certName=az keyvault certificate list --vault-name $kvName --query "[0].name" -o tsv
az keyvault certificate download --id https://$kvName.vault.azure.net/certificates/$certName -f $certPath

$subscriptionId=$(az account show -s $ws_sub_name --query id -o tsv)

$outputState = "test/plan.tfplan"
$outputJson = "test/plan.json"

terraform init -reconfigure

terraform plan -var-file "tf-variables/shared.tfvars" -var-file "tf-variables/$env.tfvars" -var "builtFrom=$builtFrom" -var "cert_path=$certPath" -var "cert_name=$certName" -var "ws_sub_id=$subscriptionId" -out="$outputState" -input=false

terraform show -json $outputState > $outputJson