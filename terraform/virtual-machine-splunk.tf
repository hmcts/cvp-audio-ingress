#---------------------------------------------------
# Splunk Ext (via module)
#---------------------------------------------------
/**module "splunk-uf" {
  source = "git::https://github.com/hmcts/terraform-module-splunk-universal-forwarder.git?ref=Splunk-change"

  count = var.vm_count

  auto_upgrade_minor_version = true

  virtual_machine_type = "vm"
  virtual_machine_id   = azurerm_linux_virtual_machine.wowza_vm[count.index].id

  splunk_username = local.splunk_admin_username
  splunk_password = random_password.splunk_admin_password.result

  tags = module.ctags.common_tags

}**/
