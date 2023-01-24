#---------------------------------------------------
# Data resources
#---------------------------------------------------

data "azurerm_key_vault" "cvp_kv" {
  name                = "cvp-${var.env}-kv"
  resource_group_name = "cvp-sharedinfra-${var.env}"
}

data "azurerm_client_config" "current" {
}

data "azurerm_key_vault_secret" "ssh_pub_key" {
  name         = "cvp-ssh-pub-key"
  key_vault_id = data.azurerm_key_vault.cvp_kv.id
}

data "azurerm_key_vault_secret" "dynatrace_token" {
  count        = var.env == "stg" || var.env == "prod" ? 1 : 0
  name         = "dynatrace-token"
  key_vault_id = data.azurerm_key_vault.cvp_kv.id
}

data "azurerm_log_analytics_workspace" "log_analytics" {
  provider = azurerm.secops

  name                = var.ws_name
  resource_group_name = var.ws_rg
}
