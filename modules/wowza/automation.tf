
# =================================================================
# =================    automation account    ======================
# =================================================================
resource "azurerm_automation_account" "vm-start-stop" {

  name                = "${var.product}-recordings-${var.env}-aa"
  location            = var.location
  resource_group_name = "${var.product}-recordings-${var.env}-rg"
  sku_name            = var.automation_account_sku_name

  identity {
    type         = "UserAssigned"
    identity_ids = module.vm_automation.cvp_aa_mi_ids
  }

  tags = var.common_tags
}

locals {
  source = "${path.module}/vm_automation"
}

#  vm shutdown/start runbook module
module "vm_automation" {
  source = "github.com/hmcts/cnp-module-automation-runbook-start-stop-vm?ref=VIH-8544" #"github.com/hmcts/cnp-module-automation-runbook-start-stop-vm

  product                 = var.product
  env                     = var.env
  location                = var.location
  automation_account_name = azurerm_automation_account.vm-start-stop.name
  tags                    = var.common_tags
  auto_acc_runbooks       = var.auto_acc_runbooks
  resource_group_id       = azurerm_resource_group.rg.id
  resource_group_name     = azurerm_resource_group.rg.name
  script_name             = var.script_name
  vm_names                = join(",", [azurerm_linux_virtual_machine.vm1.name, azurerm_linux_virtual_machine.vm2.name])

}