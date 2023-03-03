
resource "azurerm_lb_nat_rule" "wowza" {
  for_each = local.lb-rules

  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.cvp.id
  name                           = "${each.key}-nat"
  protocol                       = each.value.protocol
  frontend_port_start            = each.value.frontend_port + 1
  frontend_port_end              = each.value.frontend_port + 5
  backend_port                   = each.value.backend_port
  backend_address_pool_id        = azurerm_lb_backend_address_pool.wowza.id
  frontend_ip_configuration_name = "PrivateIPAddress"
}
