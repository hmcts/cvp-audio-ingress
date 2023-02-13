#---------------------------------------------------
# Automation account
#---------------------------------------------------
resource "azurerm_automation_account" "cvp" {
  name                = "${var.product}-recordings-${var.env}-aa"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = var.automation_account_sku_name

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mi.id]
  }

  tags = module.ctags.common_tags
}


resource "azurerm_automation_credential" "credential" {
  count = var.env == "stg" || var.env == "prod" ? 1 : 0

  name                    = "Dynatrace-Token"
  resource_group_name     = azurerm_resource_group.rg.name
  automation_account_name = azurerm_automation_account.cvp.name
  username                = "Dynatrace"
  password                = data.azurerm_key_vault_secret.dynatrace_token.value
  description             = "Dynatrace API Token"
}
