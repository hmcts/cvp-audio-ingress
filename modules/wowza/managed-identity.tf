
resource "azurerm_user_assigned_identity" "mi" {
  resource_group_name = "managed-identities-${var.env}-rg"
  location            = azurerm_resource_group.rg.location

  name = "cvp-${var.env}-mi"
}

resource "azurerm_key_vault_access_policy" "policy" {
  key_vault_id            = data.azurerm_key_vault.cvp_kv.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = azurerm_user_assigned_identity.mi.principal_id
  key_permissions         = []
  secret_permissions      = ["get", "list"]
  certificate_permissions = ["get", "list"]
  storage_permissions     = []
}

resource "azurerm_role_assignment" "mi" {
  scope                = azurerm_user_assigned_identity.mi.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.mi.principal_id
}