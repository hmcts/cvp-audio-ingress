provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "secops"
  subscription_id = var.ws_sub_id
  features {}
}

provider "azurerm" {
	alias = "shared-dns-zone"
	subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
	features {}
}