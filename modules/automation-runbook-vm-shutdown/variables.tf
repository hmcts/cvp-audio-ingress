variable "location" {
  type        = string
  description = "Location of Runbook"
  default     = "uksouth"
}
variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}
variable "tags" {
  type        = map(string)
  description = "Runbook Tags"
}

variable "application_id_collection" {
  type        = list(string)
  description = "List of Application IDs to manage"
  default     = []
}

variable "source_managed_identity_id" {
  type        = string
  description = "Managed Identity to authenticate with. Default will use current context."
  default     = ""
}

## Azure Automation
variable "automation_account_name" {
  type        = string
  description = "automation account name"
}

variable "automation_account_sku_name" {
  type        = string
  description = "Azure B2C SKU name"
  default     = "Basic"
  validation {
    condition     = contains(["Basic"], var.automation_account_sku_name)
    error_message = "Azure Automation Account SKUs are limited to Basic."
  }
}

