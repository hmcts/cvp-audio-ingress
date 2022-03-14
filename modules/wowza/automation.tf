resource "azurerm_automation_account" "vm-start-stop" {

  name                = "${var.product}-recordings-${var.env}-aa"
  location            = var.location
  resource_group_name = "${var.product}-recordings-${var.env}-rg"
  sku_name            = var.automation_account_sku_name

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mi.id]
  }

  tags = var.common_tags
}

module "vm_automation" {
  source = "git::https://github.com/hmcts/cnp-module-automation-runbook-start-stop-vm"

  product                 = "${var.product}-recordings"
  env                     = var.env
  location                = var.location
  automation_account_name = azurerm_automation_account.vm-start-stop.name
  tags                    = var.common_tags
  schedules               = var.schedules
  resource_group_name     = azurerm_resource_group.rg.name
  vm_names                = [azurerm_linux_virtual_machine.vm1.name, azurerm_linux_virtual_machine.vm2.name]
  mi_principal_id         = azurerm_user_assigned_identity.mi.principal_id
}