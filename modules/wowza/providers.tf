provider "azurerm" {
  version = ">= 2.7.0"
  features {}
}

provider "azurerm" {
  alias           = "secops"
  subscription_id = "DCD-CNP-${var.env}"
  version         = ">= 2.7.0"
  features {}
}