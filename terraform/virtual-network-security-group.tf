#---------------------------------------------------
# NSG - Make dynamic
#---------------------------------------------------
resource "azurerm_network_security_group" "sg" {

  name = "${local.service_name}-sg"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  #ingress rules
  security_rule {
    name                       = "RTMPS"
    priority                   = 1040
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = var.rtmps_source_address_prefixes
    destination_address_prefix = "*"
  }

  #egress rules
  security_rule {
    name                       = "Required_Packages_443"
    priority                   = 1041
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
  security_rule {
    name                       = "Required_Packages_80"
    priority                   = 1042
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
  security_rule {
    name                       = "DNS_53"
    priority                   = 1043
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
  security_rule {
    name                       = "Sftp"
    priority                   = 1044
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
  security_rule {
    name                       = "VNet"
    priority                   = 1045
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }
  security_rule {
    name                       = "Deny_All"
    priority                   = 4096
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = local.common_tags
}

#---------------------------------------------------
# Assign NSG to Subnet
#---------------------------------------------------
resource "azurerm_subnet_network_security_group_association" "sg_assoc_subnet" {
  subnet_id                 = azurerm_subnet.sn.id
  network_security_group_id = azurerm_network_security_group.sg.id
}