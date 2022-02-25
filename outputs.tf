output "rest_password" {
  description = ""
  value       = module.wowza.rest_password
  sensitive   = true
}

output "stream_password" {
  description = ""
  value       = module.wowza.stream_password
  sensitive   = true
}

# output "lb_pip" {
#   description = "Public IP for LB - This needs to be added to https://github.com/hmcts/azure-public-dns"
#   value       = module.wowza.lb_pip
# }

output "mi_principal_id" {
  description = "mi_principal_id"
  value       = module.wowza.principal_id
}
output "vm_names" {
  description = "vm_names"
  value       = module.wowza.vm_names
}
output "resource_group_name" {
  description = "resource_group_name"
  value       = module.wowza.resource_group_name
}
output "vm_target_status" {
  description = "vm_target_status"
  value       = module.wowza.vm_target_status
}
output "vm_change_status" {
  description = "vm_change_status"
  value       = module.wowza.vm_change_status
}