terraform {
  backend "azurerm" {
  }
  required_version = ">= 1.0.4"
  required_providers {
    azurerm  = ">= 2.34.0"
    template = "~> 2.1"
    random   = ">= 2"
  }
}
