output "function_app_id" {
  description = "ID of the created Function App"
  value       = azurerm_function_app.function_app.id
}

output "function_app_name" {
  description = "Name of the created Function App"
  value       = azurerm_function_app.function_app.name
}

output "function_app_outbound_ip_addresses" {
  description = "Outbound IP adresses of the created Function App"
  value       = azurerm_function_app.function_app.outbound_ip_addresses
}

output "function_app_possible_outbound_ip_addresses" {
  description = "All possible outbound IP adresses of the created Function App"
  value       = azurerm_function_app.function_app.possible_outbound_ip_addresses
}

output "function_app_connection_string" {
  description = "Connection string of the created Function App"
  value       = azurerm_function_app.function_app.connection_string
  sensitive   = true
}

output "function_app_identity" {
  value       = try(azurerm_function_app.function_app.identity[0], null)
  description = "Identity block output of the Function App"
}
