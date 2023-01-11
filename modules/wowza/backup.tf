resource "azurerm_recovery_services_vault" "backup_vault" {
  name                = "${local.service_name}-rsv"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  storage_mode_type   = "LocallyRedundant"

  soft_delete_enabled = true
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
  for_each            = local.vms
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.backup_vault.name
  source_vm_id        = azurerm_linux_virtual_machine.each.key.id
  backup_policy_id    = azurerm_backup_policy_vm.vm_backup.id
}