terraform {
  backend "azurerm" {
  }
  required_version = "1.8.0"
  required_providers {
    azurerm  = "4.0.0"
    template = "~> 2.1"
    random   = ">= 2"
  }
}
