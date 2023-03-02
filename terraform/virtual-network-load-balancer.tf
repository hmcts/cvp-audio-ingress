#---------------------------------------------------
# Load Balancer
#---------------------------------------------------
resource "azurerm_lb" "lb" {
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
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
}

#---------------------------------------------------
# Load Balancer - Probe
#---------------------------------------------------
resource "azurerm_lb_probe" "wowza" {
  for_each = local.lb-rules

  loadbalancer_id = azurerm_lb.lb.id
  name            = "${lower(each.key)}-probe"
  port            = each.value.backend_port
  protocol        = each.value.protocol
}

#---------------------------------------------------
# Load Balancer - Rule
#---------------------------------------------------
resource "azurerm_lb_rule" "wowza" {
  for_each = local.lb-rules

  loadbalancer_id                = azurerm_lb.lb.id
  name                           = each.key
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration.0.name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.be_add_pool.id]
  probe_id                       = azurerm_lb_probe.wowza[each.key].id
  load_distribution              = "Default"
  idle_timeout_in_minutes        = 30
}