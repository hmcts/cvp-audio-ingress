variable "rg_name" {
  type        = string
  description = "Resource Group Name"
}
variable "rg_location" {
  type        = string
  description = "Resource Group Location"
}

variable "sa_name" {
  type        = string
  description = "Storage Account Name"
}
variable "sa_tags" {
  type        = map(string)
  description = "Storage Account Tags"
}
variable "sa_access_tier" {
  type    = string
  default = "Cool"
}
variable "sa_account_kind" {
  type    = string
  default = "BlobStorage"
}
variable "sa_account_tier" {
  type    = string
  default = "Standard"
}
variable "sa_account_replication_type" {
  type    = string
  default = "RAGRS"
}
variable "sa_delete_retention_policy" {
  type        = number
  description = "Storage Account Delete Retention Policy"
  default     = 365
}

variable "sa_policy" {
  type = list(object({
    name = string
    filters = object({
      prefix_match = list(string)
      blob_types   = list(string)
    })
    actions = object({
      version_delete_after_days_since_creation = number
    })
  }))
  description = "Storage Account Managment Policy"
  default     = []
}

variable "sa_lock_name" {
  type        = string
  description = "Storage Account Lock Name"
  default     = ""
}
variable "sa_lock_level" {
  type        = string
  description = "Storage Account Lock Level"
  default     = ""
}
variable "sa_lock_notes" {
  type        = string
  description = "Storage Account Lock Notes"
  default     = ""
}

variable "sa_containers" {
  type = list(object({
    name        = string
    access_type = string
  }))
  description = "List of Storage Containers"
  default     = []
}