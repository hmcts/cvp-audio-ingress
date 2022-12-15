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

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }

}

resource "azurerm_backup_protected_vm" "vm1-backup" {
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.backup_vault.name
  source_vm_id        = azurerm_linux_virtual_machine.vm1.id
  backup_policy_id    = azurerm_backup_policy_vm.vm_backup.id
}

resource "azurerm_backup_protected_vm" "vm2-backup" {
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.backup_vault.name
  source_vm_id        = azurerm_linux_virtual_machine.vm2.id
  backup_policy_id    = azurerm_backup_policy_vm.vm_backup.id
}