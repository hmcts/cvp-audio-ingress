terraform {
  backend "azurerm" {
  }
  required_version = ">= 1.3.7"
  required_providers {
    azurerm  = "3.117.1"
    template = "~> 2.1"
    random   = ">= 2"
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.4.0"
    }
  }
}
