#---------------------------------------------------
# KV Access policy to allow SAS rotaion access to rotate the SAS 
#---------------------------------------------------

resource "azurerm_key_vault_access_policy" "sas_renewal" {
  key_vault_id            = azurerm_key_vault.cvp_kv.id
  tenant_id               = azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_key_vault.cvp_kv.id

  key_permissions         = []
  secret_permissions      = ["Get", "List", "Set", "Delete"]
  certificate_permissions = []
  storage_permissions     = []
}

#---------------------------------------------------
# Key Vault access policy - MI
#---------------------------------------------------
resource "azurerm_key_vault_access_policy" "policy" {
  key_vault_id            = data.azurerm_key_vault.cvp_kv.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = azurerm_user_assigned_identity.mi.principal_id
  key_permissions         = []
  secret_permissions      = ["Get", "List"]
  certificate_permissions = ["Get", "List"]
  storage_permissions     = []
}
