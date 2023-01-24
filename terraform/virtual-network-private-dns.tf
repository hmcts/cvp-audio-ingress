#---------------------------------------------------
# DNS Private Zone
#---------------------------------------------------

data "azurerm_private_dns_zone" "blob" {
  provider = azurerm.shared-dns-zone

  name                = "privatelink.blob.core.windows.net"
  resource_group_name = "core-infra-intsvc-rg"
}

#---------------------------------------------------
# VNET Link
#---------------------------------------------------

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  provider = azurerm.shared-dns-zone

  name                  = "${azurerm_virtual_network.vnet.name}-link"
  resource_group_name   = "core-infra-intsvc-rg"
  private_dns_zone_name = data.azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = local.common_tags
}

#---------------------------------------------------
# DNS A record - Storage account
#---------------------------------------------------

resource "azurerm_private_dns_a_record" "sa_a_record" {
  provider = azurerm.shared-dns-zone

  name                = module.sa.storageaccount_name
  zone_name           = data.azurerm_private_dns_zone.blob.name
  resource_group_name = "core-infra-intsvc-rg"
  ttl                 = 300
  records             = [azurerm_private_endpoint.endpoint.private_service_connection.0.private_ip_address]
  tags                = local.common_tags
}

#---------------------------------------------------
# Private Endpoint - Storage Account
#---------------------------------------------------

resource "azurerm_private_endpoint" "endpoint" {
  name = "${module.sa.storageaccount_name}-endpoint"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  subnet_id = azurerm_subnet.sn.id

  private_service_connection {
    name                           = "${module.sa.storageaccount_name}-scon"
    private_connection_resource_id = module.sa.storageaccount_id
    subresource_names              = ["Blob"]
    is_manual_connection           = false
  }
  tags = local.common_tags
}