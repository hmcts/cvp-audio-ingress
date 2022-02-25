# locals {
#   schedule_time = "2022-04-02T10:00:00Z"
# }

# ############ automation account  + runbook #############
# resource "azurerm_automation_runbook" "vm-start-stop" {
#   name                    = "cvp-VM-start-stop-${var.env}"
#   location                = var.location
#   resource_group_name     = var.resource_group_name
#   automation_account_name = var.automation_account_name
#   log_verbose             = var.env == "prod" ? "false" : "true"
#   log_progress            = "false"
#   description             = "This is a runbook used to stop and start cvp VMs"
#   runbook_type            = "PowerShell" #"PowerShellWorkflow"
#   content                 = "./vm-start-stop.ps1"
#   publish_content_link {
#     uri = ""
#   }

#   tags = var.tags
# }

# ################# automation schedule #################
# resource "azurerm_automation_schedule" "vm-start-stop" {
#   name                    = "cvp-schedule-${var.env}"
#   resource_group_name     = var.resource_group_name
#   automation_account_name = var.automation_account_name
#   frequency               = "Day"
#   interval                = 1
#   timezone                = "Europe/London"
#   start_time              = local.schedule_time
#   description             = "This is a scheduled to check CVP VMs at ${local.schedule_time}"
# }

# resource "azurerm_automation_job_schedule" "vm-start-stop" {
#   resource_group_name     = var.resource_group_name
#   automation_account_name = var.automation_account_name
#   schedule_name           = "cvp-schedule-${var.env}"
#   runbook_name            = azurerm_automation_runbook.vm-start-stop.name

#   parameters = {
#     mi_principal_id  = azurerm_user_assigned_identity.cvp-automation-account-mi.principal_id
#     vmlist           = var.vm_names
#     resourcegroup    = var.resource_group_name
#     vm_target_status = var.vm_target_status
#     vm_change_status = var.vm_change_status
#   }
# }