param (
    $env,
    $scheduleName,
    $status
)

$automationAccountName = "cvp-recordings-$env-aa"
$resourceGroupName = "cvp-recordings-$env-rg"

# Set the automation schedule
az automation schedule update `
  --automation-account-name "$automationAccountName" `
  --name "$scheduleName" `
  --resource-group "$resourceGroupName" `
  --is-enabled $status

# Function to get the current status of the automation schedule
function Get-ScheduleStatus {
  $schedule = az automation schedule show `
      --automation-account-name "$automationAccountName" `
      --name "$scheduleName" `
      --resource-group "$resourceGroupName" `
      --query "isEnabled" `
      --output tsv

  Write-Host "Current status of the schedule '$scheduleName': $schedule"
  return $schedule
}

# Get the current status
Get-ScheduleStatus