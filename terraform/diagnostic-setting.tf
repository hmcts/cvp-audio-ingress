#---------------------------------------------------
# Diagnostic settings - KeyVault
#---------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "cvp-kv-diag-set" {
  name                       = "cvp-kv-${var.env}-diag-set"
  target_resource_id         = data.azurerm_key_vault.cvp_kv.id
  log_analytics_workspace_id = local.la_id

  enabled_log {
    category = "AuditEvent"

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }
}

#---------------------------------------------------
# Diagnostic settings - Storage Account
#---------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "cvp-sa-diag-set" {
  name                       = "cvp-sa-${var.env}-diag-set"
  target_resource_id         = module.sa.storageaccount_id
  log_analytics_workspace_id = local.la_id

  metric {
    category = "Capacity"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
  metric {

    category = "Transaction"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}

#---------------------------------------------------
# Diagnostic settings - NSG
#---------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "cvp-nsg-diag-set" {
  name                       = "cvp-nsg-${var.env}-diag-set"
  target_resource_id         = azurerm_network_security_group.sg.id
  log_analytics_workspace_id = local.la_id

  enabled_log {
    category = "NetworkSecurityGroupEvent"

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}

#---------------------------------------------------
# Diagnostic settings - Wowoza VM NIC
#---------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "cvp-nic-diag-set" {
  count = var.vm_count

  name                       = "cvp-nic${count.index + 1}-${var.env}-diag-set"
  target_resource_id         = azurerm_network_interface.wowza_nic[count.index].id
  log_analytics_workspace_id = local.la_id

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      days    = 0
      enabled = false
    }
  }
}

#---------------------------------------------------
# Diagnostic settings - Load Balancer
#---------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "cvp-lb-diag-set" {
  name                       = "cvp-lb-${var.env}-diag-set"
  target_resource_id         = azurerm_lb.lb.id
  log_analytics_workspace_id = local.la_id

  enabled_log {
    category = "LoadBalancerAlertEvent"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "LoadBalancerProbeHealthStatus"

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}