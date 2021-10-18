
resource "azurerm_virtual_machine_extension" "log_analytics_vm2" {
  for_each             = { for vm in var.vms : vm.name => vm }
  name                 = "${each.value.name}-ext"
  virtual_machine_id   = each.value.id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "OmsAgentForLinux"
  type_handler_version = "1.13"

  settings = <<SETTINGS
    {
        "workspaceId": "${var.log_analytics_workspace_id}"
    }
SETTINGS

  protected_settings = <<PROTECTEDSETTINGS
    {
        "workspaceKey": "${var.log_analytics_primary_shared_key}"
    }
PROTECTEDSETTINGS

  tags = var.tags
}
