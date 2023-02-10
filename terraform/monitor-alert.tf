#---------------------------------------------------
# Alert to trigger if a not healthy backup event happens
#---------------------------------------------------
resource "azurerm_monitor_metric_alert" "cvp-backup-alert" {
  name                = "${local.service_name}-backup-alert"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = azurerm_recovery_services_vault.backup_vault.id
  description         = "Alert will be triggered when a non-healthy backup event happens."

  criteria {
    metric_namespace = "Microsoft.RecoveryServices/vaults"
    metric_name      = "BackupHealthEvent"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 0
    frequency        = "PT1H"
    window_size      = "PT12H"
    severity         = 1

    dimension {
      name     = "Health Status"
      operator = "Exclude"
      values   = ["Healthy"]
    }

  }

  action {
    action_group_id = azurerm_monitor_action_group.cvp-ag.id
  }

  tags                = var.common_tags
}