output "id" {
  description = "ID of the created Function App."
  value       = azurerm_function_app_flex_consumption.main.id
}

output "name" {
  description = "Name of the created Function App."
  value       = azurerm_function_app_flex_consumption.main.name
}

output "default_hostname" {
  description = "Default hostname of the created Function App."
  value       = azurerm_function_app_flex_consumption.main.default_hostname
}

output "outbound_ip_addresses" {
  description = "Outbound IP addresses of the created Function App."
  value       = azurerm_function_app_flex_consumption.main.outbound_ip_addresses
}

output "possible_outbound_ip_addresses" {
  description = "All possible outbound IP addresses of the created Function App."
  value       = azurerm_function_app_flex_consumption.main.possible_outbound_ip_addresses
}

output "identity_principal_id" {
  description = "Function App system identity principal ID."
  value       = try(azurerm_function_app_flex_consumption.main.identity[0].principal_id, null)
}

output "resource" {
  description = "Function App resource object."
  value       = azurerm_function_app_flex_consumption.main
}

output "module_diagnostics" {
  description = "Diagnostics settings module outputs."
  value       = module.diagnostics
}
