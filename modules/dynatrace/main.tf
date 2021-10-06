data "azurerm_key_vault" "kv" {
  provider            = azurerm.core_infra
  name                = var.infra_kv
  resource_group_name = var.infra_rg
}
resource "azurerm_role_assignment" "kv_access" {
  scope                = data.azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_client_config.current.object_id
}
resource "azurerm_key_vault_access_policy" "policy" {
  key_vault_id            = data.azurerm_key_vault.kv.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id
  key_permissions         = []
  secret_permissions      = ["Get", "List"]
  certificate_permissions = []
  storage_permissions     = []
}
data "azurerm_key_vault_secret" "dynatrace_token" {
  provider     = azurerm.core_infra
  name         = var.dynatrace_token_name
  key_vault_id = data.azurerm_key_vault.kv.id
  depends_on = [
    azurerm_key_vault_access_policy.policy,
    azurerm_role_assignment.kv_access
  ]
}

data "azurerm_client_config" "current" {}

module "dynatrace-oneagent" {
  count = length(var.vm_ids)
  source   = "github.com/hmcts/terraform-module-dynatrace-oneagent"

  tenant_id            = data.azurerm_client_config.current.tenant_id
  token                = data.azurerm_key_vault_secret.dynatrace_token.value
  virtual_machine_os   = "linux"
  virtual_machine_type = "vm"
  virtual_machine_id   = var.vm_ids[count.index]
  hostgroup            = var.dynatrace_host_group
}