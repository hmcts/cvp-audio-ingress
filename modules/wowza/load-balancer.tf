
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

  tags = var.common_tags
}

resource "azurerm_lb_backend_address_pool" "be_add_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "wowza-running-probe"
  port            = 443
  protocol        = "Tcp"
}

resource "azurerm_lb_rule" "rtmps_lb_rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "RTMPS"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration.0.name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.be_add_pool.id
  probe_id                       = azurerm_lb_probe.lb_probe.id
  load_distribution              = "Default"
  idle_timeout_in_minutes        = 30
}