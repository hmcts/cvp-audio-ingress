#---------------------------------------------------
# App Service Plan (via module)
#---------------------------------------------------

module "app_service_plan" {
  source = "git::https://github.com/hmcts/cnp-module-app-service-plan?ref=master"

  asp_name            = "${var.product}-recordings-${var.env}-asp"
  env                 = var.env
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  asp_sku_size        = var.asp_sku_size
  asp_capacity        = var.asp_capacity
  common_tags         = module.ctags.common_tags

}
