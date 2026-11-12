#---------------------------------------------------
# App Service Plan (via module)
#---------------------------------------------------

module "app_service_plan" {
  source = "git@github.com:hmcts/cnp-module-app-service-plan?ref=master"

  asp_name            = "${var.product}-recordings-${var.env}-asp"
  env                 = var.env
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp"
  common_tags         = var.common_tags
  
  sku {
    tier = "FlexConsumption"
    size = "FC1"
  }
}
