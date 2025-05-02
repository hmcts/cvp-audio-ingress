#---------------------------------------------------
# Start/Stop VM runbook (via module)
#---------------------------------------------------
module "vm_automation" {
  source = "git::https://github.com/hmcts/cnp-module-automation-runbook-start-stop-vm"

  product                 = var.product
  env                     = var.env
  location                = azurerm_resource_group.rg.location
  automation_account_name = azurerm_automation_account.cvp.name
  schedules               = var.schedules
  resource_group_name     = azurerm_resource_group.rg.name
  vm_names                = azurerm_linux_virtual_machine.wowza_vm[*].name
  mi_principal_id         = azurerm_user_assigned_identity.mi.principal_id

  tags = module.ctags.common_tags

  depends_on = [
    azurerm_automation_account.cvp
  ]

}