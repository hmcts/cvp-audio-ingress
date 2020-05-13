output "vnet_id" {
  description = ""
  value       = azurerm_virtual_network.vnet.id
}

output "rest_password" {
  description = ""
  value       = random_password.restPassword.result
}

output "stream_password" {
  description = ""
  value       = random_password.streamPassword.result
}

output "lb_pip" {
  description = "Public IP for LB - This needs to be added to https://github.com/hmcts/azure-public-dns"
  value       = azurerm_public_ip.pip.ip_address
}

output "vm1_pip" {
  description = "Public IP for VM1 - This needs to be added to https://github.com/hmcts/azure-public-dns"
  value       = azurerm_public_ip.pip_vm1.ip_address
}

output "vm2_pip" {
  description = "Public IP for VM2 - This needs to be added to https://github.com/hmcts/azure-public-dns"
  value       = azurerm_public_ip.pip_vm2.ip_address
}
