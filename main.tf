locals {
  rg_name      = "${var.product}-media-service-${var.env}"
  sa_name      = "${var.product}mediaservice${var.env}"
  service_name = "${var.product}mediaservice${var.env}"
  common_tags  = module.ctags.common_tags
}

module "ctags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.env
  product     = var.product
  builtFrom   = var.builtFrom
}

module "wowza" {
  source                        = "./modules/wowza"
  location                      = var.location
  product                       = var.product
  env                           = var.env
  common_tags                   = local.common_tags
  admin_ssh_key_path            = var.admin_ssh_key_path
  address_space                 = var.address_space
  lb_IPaddress                  = var.lb_IPaddress
  num_applications              = var.num_applications
  wowza_sku                     = var.wowza_sku
  wowza_version                 = var.wowza_version
  wowza_publisher               = var.wowza_publisher
  wowza_offer                   = var.wowza_offer
  rtmps_source_address_prefixes = var.rtmps_source_address_prefixes
  dev_source_address_prefixes   = var.dev_source_address_prefixes
  ws_name                       = var.ws_name
  ws_sub_id                     = var.ws_sub_id
  ws_rg                         = var.ws_rg
  sa_recording_retention        = var.sa_recording_retention
}

resource "azurerm_dns_a_record" "wowza" {
  name                = "${var.product}-media-service-${var.env}"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_resource_group
  ttl                 = 300
  records             = [var.lb_IPaddress]
  tags                = local.common_tags
}

# =================================================================
# ========  automation account for vm shutdown/start  =============
# =================================================================

resource "azurerm_automation_account" "automation_account" {
  name                = "${var.product}-${var.env}-aa"
  location            = var.location
  resource_group_name = "${var.product}-recordings-${var.env}-rg"

  sku_name = var.automation_account_sku_name

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.mi.id]
  }

  tags = local.common_tags
}

# module "automation_runbook_client_secret_rotation" {
#   source = "git@github.com:hmcts/cnp-module-automation-runbook-app-recycle?ref=master"

#   resource_group_name = azurerm_resource_group.rg.name

#   application_id_collection = [for b2c_app in data.azuread_application.apps : b2c_app.id]

#   environment = var.env
#   product     = var.product

#   key_vault_name = module.kv.key_vault_name

#   automation_account_name = azurerm_automation_account.automation_account.name

#   target_tenant_id          = var.b2c_tenant_id
#   target_application_id     = var.b2c_client_id
#   target_application_secret = var.B2C_CLIENT_SECRET

#   source_managed_identity_id = data.azurerm_user_assigned_identity.app_mi.principal_id

#   tags = var.common_tags


#   depends_on = [
#     module.kv
#   ]
# }