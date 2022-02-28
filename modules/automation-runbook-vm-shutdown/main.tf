############ automation account  + runbook #############
resource "azurerm_automation_runbook" "vm-start-stop" {
  name                    = "cvp-VM-start-stop-${var.env}"
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_account_name
  log_verbose             = var.env == "prod" ? "false" : "true"
  log_progress            = "false"
  description             = "This is a runbook used to stop and start cvp VMs"
  runbook_type            = "PowerShell" #"PowerShellWorkflow"
  content                 = file(var.script_name)
  publish_content_link {
    uri = "https://raw.githubusercontent.com/hmcts/cvp-audio-ingress/VIH-8544/modules/automation-runbook-vm-shutdown/vm-start-stop.ps1"
  }

  tags = var.tags
}

################# automation schedule #################
resource "azurerm_automation_schedule" "vm-start-stop" {
  name                    = "cvp-schedule-${var.env}"
  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_account_name
  frequency               = var.runbook_schedule_times.frequency
  interval                = var.runbook_schedule_times.interval
  timezone                = var.runbook_schedule_times.timezone
  start_time              = var.runbook_schedule_times.start_time
  description             = "This is a scheduled to check CVP VMs at ${var.runbook_schedule_times.start_time}"
}

resource "azurerm_automation_job_schedule" "vm-start-stop" {
  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_account_name
  schedule_name           = "cvp-schedule-${var.env}"
  runbook_name            = azurerm_automation_runbook.vm-start-stop.name

  parameters = {
    mi_principal_id  = azurerm_user_assigned_identity.cvp-automation-account-mi.principal_id
    vmlist           = var.vm_names
    resourcegroup    = var.resource_group_name
    vm_target_status = var.vm_target_status
    vm_change_status = var.vm_change_status
  }
}