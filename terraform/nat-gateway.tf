#---------------------------------------------------
# PIP for NAT gateway (used for all outbound internet connections)
#---------------------------------------------------
resource "azurerm_public_ip" "cvp_nat" {
  name = "${local.service_name}-nat-pip"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = module.ctags.common_tags
}

#---------------------------------------------------
# NAT Gateway
#---------------------------------------------------
resource "azurerm_nat_gateway" "cvp" {
  name                = "${local.service_name}-nat"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "Standard"

  tags = module.ctags.common_tags
}


resource "azurerm_nat_gateway_public_ip_association" "cvp" {
  nat_gateway_id       = azurerm_nat_gateway.cvp.id
  public_ip_address_id = azurerm_public_ip.cvp_nat.id
}

resource "azurerm_subnet_nat_gateway_association" "subnet_assoc" {
  nat_gateway_id = azurerm_nat_gateway.cvp.id
  subnet_id      = azurerm_subnet.sn.id
}
