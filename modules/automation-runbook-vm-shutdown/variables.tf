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
variable "vm_target_status" {
  type        = string
  description = "Target states for running state. Valid states are 'on' or 'off'"
}
variable "vm_change_status" {
  type        = bool
  description = "Should vm states be changed"
}
variable "resource_group_id" {
  type        = string
  description = "wowza resource group id"
}
variable "runbook_name" {
  type        = string
  description = "wowza resource group id"
}

