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
  tags     = local.common_tags
}

#---------------------------------------------------
# TODO: put these somewhere
#---------------------------------------------------

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