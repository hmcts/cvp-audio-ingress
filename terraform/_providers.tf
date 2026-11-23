provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "secops"
  subscription_id = var.ws_sub_id
  features {}
}

provider "azurerm" {
  alias           = "shared-dns-zone"
  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
  features {}
}

provider "azurerm" {
  features {}
  alias           = "peering_target_vpn"
  subscription_id = local.peering_vpn_subscription
  client_id       = var.network_client_id
  client_secret   = var.network_client_secret
  tenant_id       = var.network_tenant_id
}

provider "azurerm" {
  features {}
  alias           = "peering_client"
  subscription_id = data.azurerm_client_config.current.subscription_id
  client_id       = var.network_client_id
  client_secret   = var.network_client_secret
  tenant_id       = var.network_tenant_id
}

provider "azurerm" {
  alias = "sharedservices_ithc"
  features {}
  subscription_id = "ba71a911-e0d6-4776-a1a6-079af1df7139"
}

provider "azurerm" {
  alias = "sharedservices_stg"
  features {}
  subscription_id = "ba71a911-e0d6-4776-a1a6-079af1df7139"
}

provider "azurerm" {
  alias = "sharedservices_demo"
  features {}
  subscription_id = "ba71a911-e0d6-4776-a1a6-079af1df7139"
}

provider "azurerm" {
  alias = "sharedservices_test"
  features {}
  subscription_id = "ba71a911-e0d6-4776-a1a6-079af1df7139"
}
