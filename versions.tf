terraform {
  backend "azurerm" {
  }

  required_version = ">= 1.0.4"
  required_providers {
    azurerm = ">= 2.97.0"
  }
}
