output "id" {
  description = "ID of the created Function App."
  value       = azurerm_linux_function_app.main.id
}

output "name" {
  description = "Name of the created Function App."
  value       = azurerm_linux_function_app.main.name
}

output "default_hostname" {
  description = "Default hostname of the created Function App."
  value       = azurerm_linux_function_app.main.default_hostname
}

output "outbound_ip_addresses" {
  description = "Outbound IP adresses of the created Function App."
  value       = azurerm_linux_function_app.main.outbound_ip_addresses
}

output "possible_outbound_ip_addresses" {
  description = "All possible outbound IP adresses of the created Function App."
  value       = azurerm_linux_function_app.main.possible_outbound_ip_addresses
}

output "connection_string" {
  description = "Connection string of the created Function App."
  value       = azurerm_linux_function_app.main.connection_string
  sensitive   = true
}

output "identity_principal_id" {
  description = " Function App system identity principal ID."
  value       = try(azurerm_linux_function_app.main.identity[0].principal_id, null)
}

output "resource" {
  description = "Function App resource object."
  value       = azurerm_linux_function_app.main
}

output "module_diagnostics" {
  description = "Diagnostics settings module outputs."
  value       = module.diagnostics
}

output "slot_name" {
  description = "Name of the Function App slot."
  value       = try(azurerm_linux_function_app_slot.staging[0].name, null)
}

output "slot_default_hostname" {
  description = "Default hostname of the Function App slot."
  value       = try(azurerm_linux_function_app_slot.staging[0].default_hostname, null)
}

output "slot_identity" {
  description = "Identity block output of the Function App slot."
  value       = try(azurerm_linux_function_app_slot.staging[0].identity[0], null)
}

output "resource_slot" {
  description = "Function App staging slot resource object."
  value       = one(azurerm_linux_function_app_slot.staging[*])
}
