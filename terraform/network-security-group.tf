module "nsg" {
  source = "git::https://github.com/hmcts/terraform-module-network-security-group.git?ref=v1.0.0"

  network_security_group_name = "${local.service_name}-nsg"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location

  subnet_ids = {
    "${azurerm_subnet.sn.name}" = azurerm_subnet.sn.id
  }

  tags = module.ctags.common_tags

  custom_rules = [
    # INGRESS
    {
      access                       = "Allow"
      description                  = "Allow RTMPS"
      destination_address_prefix   = "*"
      destination_port_range       = "443"
      direction                    = "Inbound"
      name                         = "Allow_RTMPS"
      priority                     = 100
      protocol                     = "Tcp"
      source_address_prefixes      = var.rtmps_source_address_prefixes
      source_port_range            = "*"
    },
    {
      access                     = "Allow"
      description                = "Allow SSH from VPN"
      destination_address_prefix = "*"
      destination_port_range     = "22"
      direction                  = "Inbound"
      name                       = "Allow_VPN_SSH"
      priority                   = 200
      protocol                   = "Tcp"
      source_address_prefixes    = var.vpn_source_address_prefixes
      source_port_range          = "*"
    },
    {
      access                     = "Allow"
      description                = "Allow access to Wowza SE Manager"
      destination_address_prefix = var.lb_IPaddress
      destination_port_ranges    = ["8090","8091","8092"]
      direction                  = "Inbound"
      name                       = "Allow_WSEM"
      priority                   = 300
      protocol                   = "Tcp"
      source_address_prefixes    = var.vpn_source_address_prefixes
      source_port_range          = "*"
    },
    {
      access                     = "Allow"
      description                = "Allow access to Wowza API"
      destination_address_prefix = var.lb_IPaddress
      destination_port_ranges    = ["8087","8088","8089"]
      direction                  = "Inbound"
      name                       = "Allow_WSE_API"
      priority                   = 400
      protocol                   = "Tcp"
      source_address_prefixes    = concat(var.vpn_source_address_prefixes, var.rtmps_source_address_prefixes)
      source_port_range          = "*"
    },
    # EGRESS
    {
      access                     = "Allow"
      description                = "Allow Required Packages 80"
      destination_address_prefix = "Internet"
      destination_port_range     = "80"
      direction                  = "Outbound"
      name                       = "Allow_Required_Packages_80"
      priority                   = 100
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
    },
    {
      access                     = "Allow"
      description                = "Allow Required Packages 443"
      destination_address_prefix = "Internet"
      destination_port_range     = "443"
      direction                  = "Outbound"
      name                       = "Allow_Required_Packages_443"
      priority                   = 200
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
    },
    {
      access                     = "Allow"
      description                = "Allow DNS 53"
      destination_address_prefix = "Internet"
      destination_port_range     = "53"
      direction                  = "Outbound"
      name                       = "Allow_DNS_53"
      priority                   = 300
      protocol                   = "Udp"
      source_address_prefix      = "*"
      source_port_range          = "*"
    },
    {
      access                     = "Allow"
      description                = "Allow SFTP 22"
      destination_address_prefix = "Internet"
      destination_port_range     = "22"
      direction                  = "Outbound"
      name                       = "Allow_SFTP_22"
      priority                   = 400
      protocol                   = "Udp"
      source_address_prefix      = "*"
      source_port_range          = "*"
    }
  ]
}