output "vnet_id" {
  description = ""
  value       = azurerm_virtual_network.vnet.id
}

output "vm1_name" {
  description = "name of virtual machine 1"
  value       = azurerm_linux_virtual_machine.vm1.name
}
output "vm2_name" {
  description = "name of virtual machine 2"
  value       = azurerm_linux_virtual_machine.vm2.name
}
output "rest_password" {
  description = ""
  value       = random_password.restPassword.result
  sensitive   = true
}
output "stream_password" {
  description = ""
  value       = random_password.streamPassword.result
  sensitive   = true
}

// output "lb_pip" {
//   description = "Public IP for LB - This needs to be added to https://github.com/hmcts/azure-public-dns"
//   value       = azurerm_private_ip.pip.ip_address
// }
# output "aa_mi_id" {
#   description = "automation account managed identity id"
#   value       = module.vm_automation.aa_mi_id
# }