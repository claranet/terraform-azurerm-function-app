output "function_app_id" {
  description = "Id of the created Function App"
  value       = module.function_app.function_app_id
}

output "function_app_name" {
  description = "Name of the created Function App"
  value       = module.function_app.function_app_name
}

output "function_app_outbound_ip_addresses" {
  description = "Outbound IP adresses of the created Function App"
  value       = module.function_app.function_app_outbound_ip_addresses
}

output "function_app_connection_string" {
  description = "Connection string of the created Function App"
  value       = module.function_app.function_app_connection_string
  sensitive   = true
}

output "function_app_identity" {
  value       = module.function_app.function_app_identity
  description = "Identity block output of the Function App"
}
