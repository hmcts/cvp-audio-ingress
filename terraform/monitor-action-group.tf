resource "azurerm_monitor_action_group" "cvp-ag" {
  name                = "${local.service_name}-backup-alerts-ag"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "CVPBackup"

  dynamic "email_receiver" {
    for_each = var.vm_backup_alert_emails
    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email
    }
  }
}

