locals {
  dynatrace_token_name          = "dynatrace-token"
  key_vault_resource_group_name = "cvp-sharedinfra-${var.env}"
  key_vault_name                = "cvp-${var.env}-kv"
}

data "azurerm_key_vault" "kv" {
  name                = local.key_vault_name
  resource_group_name = local.key_vault_resource_group_name
}

data "azurerm_key_vault_secret" "dynatrace_token" {
  name         = local.dynatrace_token_name
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_client_config" "current" {}

module "dynatrace-oneagent" {
  count  = length(var.vm_ids)
  source = "github.com/hmcts/terraform-module-dynatrace-oneagent"

  tenant_id            = var.dynatrace_tenant_id
  token                = data.azurerm_key_vault_secret.dynatrace_token.value
  virtual_machine_os   = "linux"
  virtual_machine_type = "vm"
  virtual_machine_id   = var.vm_ids[count.index]
  hostgroup            = var.dynatrace_host_group
}