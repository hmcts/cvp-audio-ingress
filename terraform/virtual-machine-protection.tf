#---------------------------------------------------
# Add protection to each VM
#---------------------------------------------------
resource "azurerm_backup_protected_vm" "vms-backup" {
  count = var.vm_count

  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.backup_vault.name
  backup_policy_id    = azurerm_backup_policy_vm.vm_backup.id
  source_vm_id        = azurerm_linux_virtual_machine.wowza_vm[count.index].id

}