#---------------------------------------------------
# Automation account
#---------------------------------------------------
resource "azurerm_automation_account" "vm-start-stop" {
  name = "${var.product}-recordings-${var.env}-aa"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = var.automation_account_sku_name

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mi.id]
  }

  tags = local.common_tags
}

#---------------------------------------------------
# Start/Stop VM runbook (via module)
#---------------------------------------------------
module "vm_automation" {
  source = "git::https://github.com/hmcts/cnp-module-automation-runbook-start-stop-vm"

  product                 = var.product
  env                     = var.env
  location                = azurerm_resource_group.rg.location
  automation_account_name = azurerm_automation_account.vm-start-stop.name
  schedules               = var.schedules
  resource_group_name     = azurerm_resource_group.rg.name
  vm_names                = [azurerm_linux_virtual_machine.wowza_vm.*.name]
  mi_principal_id         = azurerm_user_assigned_identity.mi.principal_id

  tags = local.common_tags
}