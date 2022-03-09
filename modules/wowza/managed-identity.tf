
resource "azurerm_user_assigned_identity" "mi" {
  resource_group_name = "managed-identities-${var.env}-rg"
  location            = azurerm_resource_group.rg.location

  name = "cvp-${var.env}-mi"
}

resource "azurerm_key_vault_access_policy" "policy" {
  key_vault_id            = data.azurerm_key_vault.cvp_kv.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = azurerm_user_assigned_identity.mi.principal_id
  key_permissions         = []
  secret_permissions      = ["get", "list"]
  certificate_permissions = ["get", "list"]
  storage_permissions     = []
}

resource "azurerm_role_definition" "vm-status-control" {
  name        = "${var.product}-vm-status-control-${var.env}"
  scope       = azurerm_resource_group.rg.id
  description = "Custom Role for controlling virtual machines on off status"
  permissions {
    actions = [
      "Microsoft.Compute/virtualMachines/start/action",
      "Microsoft.Compute/virtualMachines/deallocate/action",
    ]
    not_actions = []
  }
  assignable_scopes = [
    azurerm_resource_group.rg.id,
  ]
}

resource "azurerm_role_assignment" "mi" {
  scope                = azurerm_user_assigned_identity.mi.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.mi.principal_id
}

resource "azurerm_role_assignment" "cvp-auto-acct-mi-role" {
  scope              = azurerm_user_assigned_identity.mi.id
  role_definition_id = azurerm_role_definition.vm-status-control.role_definition_resource_id
  principal_id       = azurerm_user_assigned_identity.mi.principal_id

  depends_on = [
    azurerm_role_definition.vm-status-control # Required otherwise terraform destroy will fail
  ]
}