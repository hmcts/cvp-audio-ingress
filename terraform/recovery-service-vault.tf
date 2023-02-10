#---------------------------------------------------
# Vault for VM backups
#---------------------------------------------------
resource "azurerm_recovery_services_vault" "backup_vault" {
  name = "${local.service_name}-rsv"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku                 = "Standard"
  storage_mode_type   = "LocallyRedundant"
  soft_delete_enabled = false
  tags                = var.common_tags
}
