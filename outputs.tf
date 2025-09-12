output "id" {
  description = "ID of the created Function App."
  value       = local.function_app.id
}

output "name" {
  description = "Name of the created Function App."
  value       = local.function_app.name
}

output "default_hostname" {
  description = "Default hostname of the created Function App."
  value       = local.function_app.default_hostname
}

output "outbound_ip_addresses" {
  description = "Outbound IP adresses of the created Function App."
  value       = local.function_app.outbound_ip_addresses
}

output "possible_outbound_ip_addresses" {
  description = "All possible outbound IP adresses of the created Function App."
  value       = local.function_app.possible_outbound_ip_addresses
}

output "connection_string" {
  description = "Connection string of the created Function App."
  value       = local.function_app.connection_string
  sensitive   = true
}

output "identity_principal_id" {
  description = "Identity principal ID output of the Function App."
  value       = try(local.function_app.identity[0].principal_id, null)
}

output "slot_id" {
  description = "ID of the Function App slot."
  value       = try(local.staging_slot.id, null)
}

output "slot_name" {
  description = "Name of the Function App slot."
  value       = try(local.staging_slot.name, null)
}

output "slot_default_hostname" {
  description = "Default hostname of the Function App slot."
  value       = try(local.staging_slot.default_hostname, null)
}

output "slot_identity_principal_id" {
  description = "Identity block output of the Function App slot."
  value       = try(local.staging_slot.identity[0].principal_id, null)
}

output "resource" {
  description = "Function App resource object."
  value       = local.function_app
}

output "resource_slot" {
  description = "Function App staging slot resource object."
  value       = local.staging_slot
}
