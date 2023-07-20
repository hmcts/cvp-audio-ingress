#---------------------------------------------------
# Dynatrace alert (via module)
#---------------------------------------------------
module "dynatrace_runbook" {
  source = "git::https://github.com/hmcts/cnp-module-automation-runbook-new-dynatrace-alert.git?ref=v1.0.0"

  automation_account_name = azurerm_automation_account.cvp.name
  resource_group_name     = azurerm_resource_group.rg.name
  location                = azurerm_resource_group.rg.location

  tags = module.ctags.common_tags

  depends_on = [
    azurerm_automation_account.cvp
  ]

}

#---------------------------------------------------
# Webhook to trigger Dynatrace alert runbook
#---------------------------------------------------
resource "azurerm_automation_webhook" "webhook_back_unhealthy" {

  count = var.env == "stg" || var.env == "prod" ? var.vm_count : 0

  name                    = "CVP - '${local.service_name}-vm${count.index + 1}' backup not healthy."
  resource_group_name     = azurerm_resource_group.rg.name
  automation_account_name = azurerm_automation_account.cvp.name
  expiry_time             = "2028-12-31T00:00:00Z"
  enabled                 = true
  runbook_name            = module.dynatrace_runbook.runbook_name

  parameters = {
    dynatracetenant  = var.dynatrace_tenant
    credentialname   = "Dynatrace-Token"
    alertname        = "CVP - '${local.service_name}-vm${count.index + 1}' backup not healthy."
    alertdescription = "A non-healty backup event has triggered, please investigate"
    entitytype       = "HOST"
    entityname       = "${local.service_name}-vm${count.index + 1}"
    eventype         = "ERROR_EVENT"
  }
}
