provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "secops"
  subscription_id = var.ws_sub_id
  features {}
}

provider "azurerm" {
  alias           = "reform"
  subscription_id = var.reforms_sub_id
  features {}
}