#---------------------------------------------------
# Add protection to each VM
#---------------------------------------------------
resource "azurerm_backup_protected_vm" "vms-backup" {
  count = var.env == "prod" ? var.vm_count : 0

  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.backup_vault[0].name
  backup_policy_id    = azurerm_backup_policy_vm.vm_backup[0].id
  source_vm_id        = azurerm_linux_virtual_machine.wowza_vm[count.index].id

}