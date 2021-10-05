variable "vm_ids" {
  type        = list(string)
  description = "List of Virtual Machine IDs to install Dynatrace on"
}
variable "env" {
  type        = string
  description = "Environment"
}

## Dynatrace
variable "infra_kv" {
  type        = string
  description = "Core Infrastructure Key Vault"
}
variable "infra_subscription_id" {
  type        = string
  description = "Core Infrastructure Subscription ID"
}
variable "infra_rg" {
  type        = string
  description = "Core Infrastructure Key Vault Resource Group"
}
variable "dynatrace_token_name" {
  type        = string
  description = "Dynatrace Key Vault Secret Name"
}