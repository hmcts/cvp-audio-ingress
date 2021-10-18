
resource "azurerm_storage_container" "deployment_details" {
  name                  = "deployment"
  storage_account_name  = module.sa.storageaccount_name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "deployment_flag" {
  name                   = "deployment-flag.txt"
  storage_account_name   = module.sa.storageaccount_name
  storage_container_name = azurerm_storage_container.deployment_details.name
  type                   = "Block"
  source_content         = timestamp()
}