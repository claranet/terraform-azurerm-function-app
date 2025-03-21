output "storage_account_id" {
  description = "Storage Account ID, empty if connection string provided."
  value       = local.function_output.storage_account_id
}

output "storage_account_name" {
  description = "Storage Account name, empty if connection string provided."
  value       = local.function_output.storage_account_name
}

output "storage_account_primary_connection_string" {
  description = "Storage Account primary connection string, empty if connection string provided."
  value       = local.function_output.storage_account_primary_connection_string
  sensitive   = true
}

output "storage_account_primary_access_key" {
  description = "Storage Account primary access key, empty if connection string provided."
  value       = local.function_output.storage_account_primary_access_key
  sensitive   = true
}

output "storage_account_secondary_connection_string" {
  description = "Storage Account secondary connection string, empty if connection string provided."
  value       = local.function_output.storage_account_secondary_connection_string
  sensitive   = true
}

output "storage_account_secondary_access_key" {
  description = "Storage Account secondary access key, empty if connection string provided."
  value       = local.function_output.storage_account_secondary_access_key
  sensitive   = true
}

output "storage_account_network_rules" {
  description = "Storage Account associated network rules."
  value       = local.function_output.storage_account_network_rules
}
