output "function_app_id" {
  description = "ID of the created Function App"
  value       = azurerm_linux_function_app.linux_function.id
}

output "function_app_name" {
  description = "Name of the created Function App"
  value       = azurerm_linux_function_app.linux_function.name
}

output "function_app_default_hostname" {
  description = "Default hostname of the created Function App"
  value       = azurerm_linux_function_app.linux_function.default_hostname
}

output "function_app_outbound_ip_addresses" {
  description = "Outbound IP adresses of the created Function App"
  value       = azurerm_linux_function_app.linux_function.outbound_ip_addresses
}

output "function_app_possible_outbound_ip_addresses" {
  description = "All possible outbound IP adresses of the created Function App"
  value       = azurerm_linux_function_app.linux_function.possible_outbound_ip_addresses
}

output "function_app_connection_string" {
  description = "Connection string of the created Function App"
  value       = azurerm_linux_function_app.linux_function.connection_string
  sensitive   = true
}

output "function_app_identity" {
  description = "Identity block output of the Function App"
  value       = try(azurerm_linux_function_app.linux_function.identity[0], null)
}

output "function_app_slot_name" {
  description = "Name of the Function App slot"
  value       = try(azurerm_linux_function_app_slot.linux_function_slot[0].name, null)
}

output "function_app_slot_default_hostname" {
  description = "Default hostname of the Function App slot"
  value       = try(azurerm_linux_function_app_slot.linux_function_slot[0].default_hostname, null)
}

output "function_app_slot_identity" {
  description = "Identity block output of the Function App slot"
  value       = try(azurerm_linux_function_app_slot.linux_function_slot[0].identity[0], null)
}
