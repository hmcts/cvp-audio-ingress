resource "azurerm_storage_account" "sa" {
  name                      = var.sa_name
  resource_group_name       = var.rg_name
  location                  = var.rg_location
  tags                      = var.sa_tags
  access_tier               = var.sa_access_tier
  account_kind              = var.sa_account_kind
  account_tier              = var.sa_account_tier
  account_replication_type  = var.sa_account_replication_type
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  blob_properties {
    delete_retention_policy {
      days = var.sa_delete_retention_policy
    }
  }
}

resource "azurerm_storage_management_policy" "sa_policy" {
  storage_account_id = azurerm_storage_account.sa.id

  dynamic "rule" {
    for_each = var.sa_policy
    content {
      name    = rule.name
      enabled = true
      filters {
        prefix_match = rule.filters.prefix_match
        blob_types   = rule.filters.blob_types
      }
      actions {
        version {
          delete_after_days_since_creation = rule.actions.version_delete_after_days_since_creation
        }
      }
    }
  }
}

resource "azurerm_management_lock" "sa" {
  count      = var.sa_lock_name == "" ? 0 : 1
  name       = var.sa_lock_name
  scope      = azurerm_storage_account.sa.id
  lock_level = var.sa_lock_level
  notes      = var.sa_lock_notes
}

module "media_containers" {
  count = length(var.sa_containers)

  source           = "./container"
  sa_name          = azurerm_storage_account.sa.name
  container_name   = var.sa_containers[count.index].name
  container_access = var.sa_containers[count.index].access_type
}
