output "rest_password" {
  description = "REST password"
  value       = random_password.restPassword
  sensitive   = true
}

output "stream_password" {
  description = "Stream password"
  value       = random_password.streamPassword
  sensitive   = true
}