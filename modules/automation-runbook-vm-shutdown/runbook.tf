
locals {
  runbook_name    = "vm-shutdown.ps1"
  runbook_content = file("${path.module}/${local.runbook_name}")
}

resource "azurerm_automation_account" "automation_account" {
  name                = var.aa_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.automation_account_sku_name

  tags = var.tags
}