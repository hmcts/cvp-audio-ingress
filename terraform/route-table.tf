resource "azurerm_route_table" "wowza" {
  name                = "${local.service_name}-route-table"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.ctags.common_tags

  dynamic "route" {
    for_each = var.route_table
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }
}

resource "azurerm_subnet_route_table_association" "wowza" {
  subnet_id      = azurerm_subnet.sn.id
  route_table_id = azurerm_route_table.wowza.id
}
