#---------------------------------------------------
# Function app for crime
#---------------------------------------------------

resource "azurerm_function_app" "function_app_crime" {
  name                       = "${var.product}-recordings-${var.env}-facrimetest"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = module.app_service_plan.asp_id
  storage_account_name       = module.sa.storageaccount_name
  storage_account_access_key = module.sa.storageaccount_primary_access_key

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mi_function.id]
  }
}