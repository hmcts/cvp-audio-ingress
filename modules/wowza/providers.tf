provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "secops"
  subscription_id = var.ws_sub_id
  features {}
}

provider "azurerm"{
  alias = "reform"
  subscription_id = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
  features {}
}