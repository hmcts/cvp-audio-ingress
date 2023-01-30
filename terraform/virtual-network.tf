#--------------------------------
# VNET
#--------------------------------
resource "azurerm_virtual_network" "vnet" {
  name          = "${local.service_name}-vnet"
  address_space = [var.address_space]

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = module.ctags.common_tags
}

#---------------------------------------------------
# Subnet
#---------------------------------------------------
resource "azurerm_subnet" "sn" {
  name                 = "wowza"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.address_space]
  service_endpoints    = ["Microsoft.KeyVault"]

  enforce_private_link_endpoint_network_policies = true
}
