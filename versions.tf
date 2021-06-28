terraform {
  backend "azurerm" {
  }

  required_version = ">= 1.0.0"

  required_providers {
    azurerm = ">= 2.64.0"
  }
}
