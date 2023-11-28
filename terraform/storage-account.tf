#---------------------------------------------------
# Storage Account (via module)
#---------------------------------------------------
#tfsec:ignore:azure-storage-default-action-deny
module "sa" {
  source = "git::https://github.com/hmcts/cnp-module-storage-account.git?ref=master"

  env = var.env

  storage_account_name = "${replace(lower(local.service_name), "-", "")}sa"
  common_tags          = module.ctags.common_tags

  default_action = "Deny"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  account_tier             = var.sa_account_tier
  account_kind             = var.sa_account_kind
  account_replication_type = var.sa_account_replication_type
  access_tier              = var.sa_access_tier

  policy = [
    {
      name = "RecordingRetention"
      filters = {
        prefix_match = ["${local.main_container_name}/"]
        blob_types   = ["blockBlob"]
      }
      actions = {
        version_delete_after_days_since_creation = var.sa_recording_retention
      }
    }
  ]
  containers = [
    {
      name        = local.main_container_name
      access_type = "private"
    },
    {
      name        = local.wowza_logs_container_name
      access_type = "private"
    },
    // Keep these containers until all recordings have been migrated to `recordings` container
    {
      name        = "${local.main_container_name}01"
      access_type = "private"
    },
    {
      name        = "${local.main_container_name}02"
      access_type = "private"
    }
  ]
}

resource "azurerm_storage_management_policy" "sa" {
  storage_account_id = module.sa.storageaccount_id
  rule {
    name    = "RecordingRetention"
    enabled = true
    filters {
      prefix_match = ["${local.main_container_name}/"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_creation_greater_than = var.sa_recording_retention
      }
    }
  }
}

#---------------------------------------------------
# Lock to prevent deletion of storage account
#---------------------------------------------------
resource "azurerm_management_lock" "sa" {
  name       = "resource-sa"
  scope      = module.sa.storageaccount_id
  lock_level = "CanNotDelete"
  notes      = "Lock to prevent deletion of storage account"
}
