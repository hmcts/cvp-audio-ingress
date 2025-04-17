param (
    $env,
    $scheduleName
)

$automationAccountName = "cvp-recordings-$env-aa"
Set-AzAutomationSchedule -AutomationAccountName $automationAccountName `
-Name $scheduleName -IsEnabled $false -ResourceGroupName "cvp-recordings-$env-rg"