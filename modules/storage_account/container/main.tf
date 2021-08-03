

resource "azurerm_storage_container" "sa_container" {
  name                  = var.container_name
  storage_account_name  = var.sa_name
  container_access_type = var.container_access
}