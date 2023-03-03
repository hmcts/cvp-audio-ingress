
resource "azurerm_lb_nat_rule" "wowza_nat" {
  count = var.vm_count

  name                           = "wowza-443-${azurerm_linux_virtual_machine.wowza_vm[count.index].name}"
  protocol                       = local.lb-rules["wowza"].protocol
  frontend_port                  = local.lb-rules["wowza"].frontend_port + count.index + 1
  backend_port                   = local.lb-rules["wowza"].backend_port
  frontend_ip_configuration_name = azurerm_lb.cvp.frontend_ip_configuration[0].name  
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.cvp.id
}

resource "azurerm_network_interface_nat_rule_association" "wowza_nat_ass" {
  count = var.vm_count

  network_interface_id  = azurerm_network_interface.wowza_nic[count.index].id
  ip_configuration_name = azurerm_network_interface.wowza_nic[count.index].ip_configuration[0].name 
  nat_rule_id           = azurerm_lb_nat_rule.wowza_nat[count.index].id
}