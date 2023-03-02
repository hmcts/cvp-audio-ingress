#---------------------------------------------------
# NIC
#---------------------------------------------------
resource "azurerm_network_interface" "wowza_nic" {
  count = var.vm_count

  name = "${local.service_name}-nic${count.index + 1}"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "wowzaConfiguration"
    subnet_id                     = azurerm_subnet.sn.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = module.ctags.common_tags
}

#---------------------------------------------------
# NSG association
#---------------------------------------------------
resource "azurerm_network_interface_security_group_association" "sg_assoc" {
  count = var.vm_count

  network_interface_id      = azurerm_network_interface.wowza_nic[count.index].id
  network_security_group_id = azurerm_network_security_group.sg.id
}

#---------------------------------------------------
# Backend accociation
#---------------------------------------------------
resource "azurerm_network_interface_backend_address_pool_association" "be_add_pool_assoc" {
  count = var.vm_count

  network_interface_id    = azurerm_network_interface.wowza_nic[count.index].id
  ip_configuration_name   = azurerm_network_interface.wowza_nic[count.index].ip_configuration.0.name
  backend_address_pool_id = azurerm_lb_backend_address_pool.wowza.id
}
