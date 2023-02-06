#---------------------------------------------------
# Automation account
#---------------------------------------------------
resource "azurerm_automation_account" "cvp" {
  name = "${var.product}-recordings-${var.env}-aa"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = var.automation_account_sku_name

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mi.id]
  }

  tags = module.ctags.common_tags
}
