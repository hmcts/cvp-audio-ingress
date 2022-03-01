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

  tags = local.common_tags
}

# =================================================================
# =================    automation account    ======================
# =================================================================

resource "azurerm_automation_account" "vm-start-stop" {
  count = var.vm_status.auto_acc_change_vm_status == true ? 1 : 0

  name                = "${var.product}-recordings-${var.env}-aa"
  location            = var.location
  resource_group_name = "${var.product}-recordings-${var.env}-rg"
  sku_name            = var.automation_account_sku_name

  identity {
    type         = "UserAssigned"
    identity_ids = [module.vm_automation[0].cvp_aa_mi_id]
  }

  tags = local.common_tags
}

#  vm shutdown/start runbook module
module "vm_automation" {
  count = var.vm_status.auto_acc_change_vm_status == true ? 1 : 0

  source = "github.com/hmcts/cnp-module-automation-runbook-start-stop-vm"

  # source                  = "./modules/automation-runbook-vm-shutdown"
  automation_account_name = azurerm_automation_account.vm-start-stop[0].name
  location                = var.location
  env                     = var.env
  resource_group_id       = module.wowza.wowza_rg_id
  vm_status               = var.vm_status
  runbook_schedule_times  = var.runbook_schedule_times
  tags                    = local.common_tags
  auto_acc_runbook_names = {
    resource_group_name         = "${var.product}-recordings-${var.env}-rg"
    runbook_name                = "${var.product}-recordings-VM-start-stop-${var.env}"
    schedule_name               = "${var.product}-recordings-schedule-${var.env}"
    job_schedule_name           = "${var.product}-recordings-schedule-${var.env}"
    user_assigned_identity_name = "${var.product}-recordings-automation-mi-${var.env}"
    role_definition_name        = "${var.product}-recordings-vm-control-${var.env}"
    script_name                 = "XYZ${path.module}ZYX/${var.script_name}"
    vm_names                    = join(",", [module.wowza.vm1_name, module.wowza.vm2_name])
  }
}

