variable "location" {
  type        = string
  description = "Location of Runbook"
  default     = "uksouth"
}
variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}
variable "env" {
  type = string
}
variable "tags" {
  type        = map(string)
  description = "Runbook Tags"
}
## Azure Automation
variable "automation_account_name" {
  type        = string
  description = "automation account name"
}
variable "vm_names" {
  type = string
}
variable "vm_status" {
  default = {}
}
variable "resource_group_id" {
  type        = string
  description = "resource group id"
}
variable "script_name" {
  type        = string
  description = "script name for runbook"
}
variable "runbook_schedule_times" {
  default = {}
}
