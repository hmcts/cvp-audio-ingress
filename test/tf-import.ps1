
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

$wsSsubscriptionId=az account show -s $global:ws_sub_name --query id -o tsv

$subscriptionId=$(az account show -s $ws_sub_name --query id -o tsv)

$azResourceId="/subscriptions/$subscriptionId/resourceGroups/cvp-recordings-$env-rg/providers/Microsoft.Compute/virtualMachines/cvp-recordings-$env-vm"
$tfConfig="module.wowza.azurerm_linux_virtual_machine.vm"

terraform init -reconfigure

terraform import -var-file "tf-variables/shared.tfvars" -var-file "tf-variables/$env.tfvars" -var "builtFrom=$builtFrom" -var "ws_sub_id=$wsSsubscriptionId" $tfConfig"2" $azResourceId"2"

terraform import -var-file "tf-variables/shared.tfvars" -var-file "tf-variables/$env.tfvars" -var "builtFrom=$builtFrom" -var "ws_sub_id=$wsSsubscriptionId" $tfConfig"1" $azResourceId"1"