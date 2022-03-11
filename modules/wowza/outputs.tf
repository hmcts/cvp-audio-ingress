output "vnet_id" {
  description = ""
  value       = azurerm_virtual_network.vnet.id
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