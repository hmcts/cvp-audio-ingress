
resource "azurerm_user_assigned_identity" "mi" {
  resource_group_name = "managed-identities-${var.env}-rg"
  location            = azurerm_resource_group.rg.location

  name = "cvp-${var.env}-mi"
}

data "azurerm_dns_zone" "dns" {
  provider            = azurerm.reform
  name                = "${local.domain_dns_prefix}.platform.hmcts.net"
  resource_group_name = "reformmgmtrg"
}
resource "azurerm_role_assignment" "dns" {
  scope                = data.azurerm_dns_zone.dns.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.mi.principal_id
}