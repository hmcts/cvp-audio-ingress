#--------------------------------------------------------------
# Network Peering
#--------------------------------------------------------------

locals {
  requester_network_name                = azurerm_virtual_network.vnet.name
  requester_network_id                  = azurerm_virtual_network.vnet.id
  requester_network_resource_group_name = azurerm_resource_group.rg.name

  accepter_network_name                = "core-infra-vnet-mgmt"
  accepter_network_resource_group_name = "rg-mgmt"

  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}
data "azurerm_virtual_network" "core_vnet" {
  provider            = azurerm.reform_cft_mgmt
  name                = local.accepter_network_name
  resource_group_name = local.accepter_network_resource_group_name
}
locals {
  accepter_network_id = data.azurerm_virtual_network.core_vnet.id
}

resource "azurerm_virtual_network_peering" "virtual_network_peering_requester" {
  name = format(
    "%s_%s_network_peering_%s",
    local.requester_network_name,
    local.accepter_network_name,
    var.env,
  )

  resource_group_name = local.requester_network_resource_group_name

  remote_virtual_network_id    = local.accepter_network_id
  virtual_network_name         = local.requester_network_name
  allow_forwarded_traffic      = local.allow_forwarded_traffic
  allow_virtual_network_access = local.allow_virtual_network_access
}

resource "azurerm_virtual_network_peering" "virtual_network_peering_accepter" {
  provider            = azurerm.reform_cft_mgmt
  name = format(
    "%s_%s_network_peering_%s",
    local.accepter_network_name,
    local.requester_network_name,
    var.env,
  )

  resource_group_name = local.accepter_network_resource_group_name

  remote_virtual_network_id    = local.requester_network_id
  virtual_network_name         = local.accepter_network_name
  allow_forwarded_traffic      = local.allow_forwarded_traffic
  allow_virtual_network_access = local.allow_virtual_network_access
}
