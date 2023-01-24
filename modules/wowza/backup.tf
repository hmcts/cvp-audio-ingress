locals {
  vmids = {
    vm1id = azurerm_linux_virtual_machine.vm1.id
    vm2id = azurerm_linux_virtual_machine.vm2.id
  }
}

resource "azurerm_recovery_services_vault" "backup_vault" {
  name                = "${local.service_name}-rsv"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  storage_mode_type   = "LocallyRedundant"

  soft_delete_enabled = false
  tags                = var.common_tags
}

resource "azurerm_backup_policy_vm" "vm_backup" {
  name                = "${local.service_name}-rsv-policy"
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.backup_vault.name

  timezone = "UTC"

  instant_restore_retention_days = 5

  backup {
    frequency = "Weekly"
    time      = "20:00"
    weekdays  = ["Sunday"]
  }

  retention_weekly {
    count    = 1
    weekdays = ["Sunday"]
  }
}

resource "azurerm_backup_protected_vm" "vms-backup" {
  for_each            = local.vmids
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.backup_vault.name
  source_vm_id        = each.value
  backup_policy_id    = azurerm_backup_policy_vm.vm_backup.id
}

resource "azurerm_monitor_action_group" "cvp-ag" {
  name                = "${local.service_name}-backup-alerts-ag"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "CVPBackup"

  email_receiver {
    name                    = "Tom Test"
    email_address           = "thomas.watson@hmcts.net"
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_metric_alert" "cvp-backup-alert" {
  name                = "${local.service_name}-backup-alert"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = azurerm_recovery_services_vault.backup_vault.id
  description         = "Alert will be triggered when a Backup event happens."
  tags                = var.common_tags

  criteria {
    metric_namespace = "Microsoft.RecoveryServices/vaults"
    metric_name      = "BackupHealthEvent"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 0

  }

  action {
    action_group_id = azurerm_monitor_action_group.cvp-ag.id
  }
}