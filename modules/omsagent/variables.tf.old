variable "vms" {
  type = list(object({
    name = string
    id   = string
  }))
  description = "List of Virtual Machine details"
}
variable "tags" {
  type        = map(string)
  description = "Tags for the Azure resources"
}


## Log Analytics
variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID"
}
variable "log_analytics_primary_shared_key" {
  type        = string
  description = "Log Analytics Primary Key"
}