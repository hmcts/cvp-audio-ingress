#---------------------------------------------------
# Common Tags
#---------------------------------------------------

module "ctags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.env
  product     = var.product
  builtFrom   = var.builtFrom
}

#--------------------------------------------------------------
# Resource Group
#--------------------------------------------------------------

resource "azurerm_resource_group" "rg" {
  name     = "${local.service_name}-rg"
  location = var.location
  tags     = module.ctags.common_tags
}

#---------------------------------------------------
# TODO: put these somewhere
#---------------------------------------------------

resource "azurerm_dns_a_record" "wowza" {
  name                = "${var.product}-media-service-${var.env}"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_resource_group
  ttl                 = 300
  records             = [var.lb_IPaddress]

  tags = module.ctags.common_tags
}

resource "random_password" "certPassword" {
  length           = 32
  special          = true
  override_special = "_%*"
}

resource "random_password" "restPassword" {
  length           = 32
  special          = true
  override_special = "_%*"
}

resource "random_password" "streamPassword" {
  length           = 32
  special          = true
  override_special = "_%*"
}

#---------------------------------------------------
# The following is required for the first deploy to prod to allow the update to new TF
#---------------------------------------------------
module "wowza" {
  source = "./modules/wowza"
}