provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "core_infra"
  subscription_id = var.infra_subscription_id
  features {}
}
