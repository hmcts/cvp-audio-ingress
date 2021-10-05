

data "azurerm_key_vault" "kv" {
  provider            = azurerm.core_infra
  name                = var.infra_kv
  resource_group_name = var.infra_rg
}

data "azurerm_key_vault_secret" "dynatrace_token" {
  provider     = azurerm.core_infra
  name         = var.dynatrace_token_name
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_client_config" "current" {}

module "dynatrace-oneagent" {
  for_each = var.vm_ids
  source   = "github.com/hmcts/terraform-module-dynatrace-oneagent"

  tenant_id            = data.azurerm_client_config.current.tenant_id
  token                = data.azurerm_key_vault_secret.dynatrace_token.value
  virtual_machine_os   = "linux"
  virtual_machine_type = "vm"
  virtual_machine_id   = each.value
  hostgroup            = var.dynatrace_host_group
}