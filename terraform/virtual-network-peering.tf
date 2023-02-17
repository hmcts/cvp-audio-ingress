

resource "azurerm_virtual_network_peering" "vnet_to_vpn_hub" {
  provider = azurerm.peering_client

  name                      = local.peering_vpn_vnet
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = "/subscriptions/${local.peering_vpn_subscription}/resourceGroups/${local.peering_vpn_resourcegroup}/providers/Microsoft.Network/virtualNetworks/${local.peering_vpn_vnet}"
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "vpn_hub_to_vnet" {
  provider = azurerm.peering_target_vpn

  name                      = azurerm_virtual_network.vnet.name
  resource_group_name       = local.peering_vpn_resourcegroup
  virtual_network_name      = each.value
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  allow_forwarded_traffic   = true
}
