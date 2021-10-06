variable "vm_ids" {
  type        = list(string)
  description = "List of Virtual Machine IDs to install Dynatrace on"
}
variable "env" {
  type        = string
  description = "Environment"
}

## Dynatrace
variable "dynatrace_host_group" {
  type        = string
  description = "Dynatrace Host Group"
}