#---------------------------------------------------
# Load Balancer
#---------------------------------------------------
resource "azurerm_lb" "cvp" {
  name                = "${local.service_name}-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "PrivateIPAddress"
    subnet_id                     = azurerm_subnet.sn.id
    private_ip_address            = var.lb_IPaddress
    private_ip_address_allocation = "Static"
  }

  tags = module.ctags.common_tags
}

#---------------------------------------------------
# Load Balancer - Backend pool
#---------------------------------------------------
resource "azurerm_lb_backend_address_pool" "wowza" {
  loadbalancer_id = azurerm_lb.cvp.id
  name            = "BackEndAddressPool"
}

#---------------------------------------------------
# Load Balancer - Probes
#---------------------------------------------------
resource "azurerm_lb_probe" "wowza" {
  for_each = local.lb-rules

  loadbalancer_id = azurerm_lb.cvp.id
  name            = "${lower(each.key)}-probe"
  port            = each.value.backend_port
  protocol        = each.value.protocol

  depends_on = [
    azurerm_lb.cvp
  ]
}

#---------------------------------------------------
# Load Balancer - Rules
#---------------------------------------------------
resource "azurerm_lb_rule" "wowza" {
  for_each = local.lb-rules

  loadbalancer_id                = azurerm_lb.cvp.id
  name                           = each.key
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = azurerm_lb.cvp.frontend_ip_configuration.0.name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.wowza.id]
  probe_id                       = azurerm_lb_probe.wowza[each.key].id
  load_distribution              = "Default"
  idle_timeout_in_minutes        = 30

  depends_on = [
    azurerm_lb.cvp
  ]
}