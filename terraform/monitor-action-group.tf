#---------------------------------------------------
# Send alerts to AA wwebhook
#---------------------------------------------------

resource "azurerm_monitor_action_group" "cvp-backup-ag" {
  count = var.vm_count

  name                = "${local.service_name}-vm${count.index + 1}-backup-alerts-ag"
  short_name          = "CVPBackupVM${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name

  automation_runbook_receiver {
    name                    = "CVP - '${local.service_name}-vm${count.index + 1}' backup not healthy."
    automation_account_id   = azurerm_automation_account.cvp.id
    runbook_name            = module.dynatrace_runbook.name
    webhook_resource_id     = azurerm_automation_webhook.webhook_back_unhealthy[0].id
    is_global_runbook       = true
    service_uri             = azurerm_automation_webhook.webhook_back_unhealthy[0].uri
    use_common_alert_schema = false
  }

  tags = module.ctags.common_tags
}
