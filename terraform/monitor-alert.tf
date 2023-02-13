#---------------------------------------------------
# Alert to trigger if a not healthy backup event happens
#---------------------------------------------------
resource "azurerm_monitor_metric_alert" "cvp-backup-alert" {

  count = var.env == "stg" || var.env == "prod" ? var.vm_count : 0

  name                = "${local.service_name}-vm${count.index + 1}-backup-alert"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_recovery_services_vault.backup_vault.id]
  description         = "Alert will be triggered when a non-healthy backup event happens."

  frequency   = "PT1H"
  window_size = "PT12H"
  severity    = 1

  criteria {
    metric_namespace = "Microsoft.RecoveryServices/vaults"
    metric_name      = "BackupHealthEvent"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 0

    dimension {
      name     = "HealthStatus"
      operator = "Exclude"
      values   = ["Healthy"]
    }

    dimension {
      name     = "BackupInstanceName"
      operator = "Include"
      values   = ["${local.service_name}-vm${count.index + 1}"]
    }

  }

  action {
    action_group_id = azurerm_monitor_action_group.cvp-backup-ag[count.index].id
  }

  tags = module.ctags.common_tags
}
