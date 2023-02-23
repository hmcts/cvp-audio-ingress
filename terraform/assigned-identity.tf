#---------------------------------------------------
# User assigned Identity
#---------------------------------------------------
resource "azurerm_user_assigned_identity" "mi" {
  resource_group_name = "managed-identities-${var.env}-rg"
  location            = azurerm_resource_group.rg.location

  name = "cvp-${var.env}-mi"
}

#---------------------------------------------------
# Add role assignment to read identity
#---------------------------------------------------
resource "azurerm_role_assignment" "mi" {
  scope                = azurerm_user_assigned_identity.mi.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.mi.principal_id
}

#---------------------------------------------------
# Allow MI to manage AKV (used by SAS runbook)
#---------------------------------------------------
resource "azurerm_role_assignment" "mi_akv" {
  scope                = data.azurerm_key_vault.cvp_kv.id
  role_definition_name = "Key Vault Contributor"
  principal_id         = azurerm_user_assigned_identity.mi.principal_id
}

#---------------------------------------------------
# Role definition for controlling Wowza VMs
#---------------------------------------------------
resource "azurerm_role_definition" "vm-status-control" {
  name = "${var.product}-vm-status-control-${var.env}"

  scope       = azurerm_resource_group.rg.id
  description = "Custom Role for controlling virtual machines on off status"

  permissions {
    actions = [
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Compute/virtualMachines/start/action",
      "Microsoft.Compute/virtualMachines/deallocate/action",
      "Microsoft.Compute/virtualMachines/runCommand/action",
    ]
    not_actions = []
  }
  assignable_scopes = [
    azurerm_resource_group.rg.id,
  ]
}

#---------------------------------------------------
# Assign VM role to identity
#---------------------------------------------------
resource "azurerm_role_assignment" "cvp-auto-acct-mi-role" {
  scope              = azurerm_resource_group.rg.id
  role_definition_id = azurerm_role_definition.vm-status-control.role_definition_resource_id
  principal_id       = azurerm_user_assigned_identity.mi.principal_id

  depends_on = [
    azurerm_role_definition.vm-status-control # Required otherwise terraform destroy will fail
  ]
} 