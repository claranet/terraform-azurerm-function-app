output "storage_account_id" {
  description = "Storage Account ID, `null` if connection string provided."
  value       = local.storage_account_output.id
}

output "storage_account_name" {
  description = "Storage Account name, `null` if connection string provided."
  value       = local.storage_account_output.name
}

output "storage_account_primary_connection_string" {
  description = "Storage Account's primary connection string, `null` if connection string provided."
  value       = local.storage_account_output.primary_connection_string
  sensitive   = true
}

output "storage_account_primary_access_key" {
  description = "Storage Account's primary access key, `null` if connection string provided."
  value       = local.storage_account_output.primary_access_key
  sensitive   = true
}

output "storage_account_secondary_connection_string" {
  description = "Storage Account's secondary connection string, `null` if connection string provided."
  value       = local.storage_account_output.secondary_connection_string
  sensitive   = true
}

output "storage_account_secondary_access_key" {
  description = "Storage Account's secondary access key, `null` if connection string provided."
  value       = local.storage_account_output.secondary_access_key
  sensitive   = true
}

output "storage_account_network_rules" {
  description = "Network rules of the Storage Account."
  value       = one(azurerm_storage_account_network_rules.main[*])
}
