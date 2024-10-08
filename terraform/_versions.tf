terraform {
  backend "azurerm" {
  }
  required_version = ">= 1.3.7"
  required_providers {
    azurerm  = "4.4.0"
    template = "~> 2.1"
    random   = ">= 2"
  }
}
