#---------------------------------------------------
# Key Vault for Function App keys
#---------------------------------------------------
resource "azurerm_key_vault" "function_keys" {

  name                = "${var.product}-function-{var.env}-kv"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  public_network_access_enabled = true

  tags = module.ctags.common_tags
}

resource "azurerm_key_vault_access_policy" "function_keys" {

  key_vault_id            = azurerm_key_vault.function_keys.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = azurerm_user_assigned_identity.mi_function.principal_id
  key_permissions         = []
  secret_permissions      = ["Get", "List", "Set", "Delete"]
  certificate_permissions = []
  storage_permissions     = []
}
