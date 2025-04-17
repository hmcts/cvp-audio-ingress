param (
    $env,
    $scheduleName,
    $status
)

$automationAccountName = "cvp-recordings-$env-aa"
$resourceGroupName = "cvp-recordings-$env-rg"

# Disable the automation schedule
az automation schedule update `
  --automation-account-name "$automationAccountName" `
  --name "$scheduleName" `
  --resource-group "$resourceGroupName" `
  --is-enabled $status