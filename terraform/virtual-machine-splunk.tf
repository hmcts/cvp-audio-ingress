#---------------------------------------------------
# Splunk Ext 
#---------------------------------------------------

# locals {
#   cse_script = "./install-splunk-forwarder-service.sh ${local.splunk_admin_username} ${random_password.splunk_admin_password.result} dynatrace_forwarders"
#   script_uri = "https://raw.githubusercontent.com/hmcts/terraform-module-splunk-universal-forwarder/master/scripts/install-splunk-forwarder-service.sh"
# }

# resource "azurerm_virtual_machine_extension" "splunk" {

#   count = var.vm_count

#   name                       = "splunk-universal-forwarder"
#   virtual_machine_id         = azurerm_linux_virtual_machine.wowza_vm[count.index].id
#   publisher                  = "Microsoft.Azure.Extensions"
#   type                       = "CustomScript"
#   type_handler_version       = "2.1"
#   auto_upgrade_minor_version = true
#   tags                       = module.ctags.common_tags
#   protected_settings         = <<PROTECTED_SETTINGS
#     {
#       "fileUris": ["${local.script_uri}"],
#       "commandToExecute": "${local.cse_script}"
#     }
#     PROTECTED_SETTINGS
# }

module "splunk-uf" {
  source = "git::https://github.com/hmcts/terraform-module-splunk-universal-forwarder.git?ref=master"
  
  count = var.vm_count

  auto_upgrade_minor_version = true

  virtual_machine_type = "vm"
  virtual_machine_id   = azurerm_linux_virtual_machine.wowza_vm[count.index].id

  splunk_username = local.splunk_admin_username
  splunk_password = random_password.splunk_admin_password.result

  tags = module.ctags.common_tags

}