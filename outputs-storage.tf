output "storage_account_id" {
  description = "Storage Account ID."
  value       = nonsensitive(local.storage_account.id)
}

output "storage_account_name" {
  description = "Storage Account name."
  value       = nonsensitive(local.storage_account.name)
}

output "storage_account_primary_connection_string" {
  description = "Storage Account primary connection string."
  value       = local.storage_account.primary_connection_string
  sensitive   = true
}

output "storage_account_primary_access_key" {
  description = "Storage Account primary access key."
  value       = local.storage_account.primary_access_key
  sensitive   = true
}

output "storage_account_secondary_connection_string" {
  description = "Storage Account secondary connection string."
  value       = local.storage_account.secondary_connection_string
  sensitive   = true
}

output "storage_account_secondary_access_key" {
  description = "Storage Account secondary access key."
  value       = local.storage_account.secondary_access_key
  sensitive   = true
}

output "storage_account_network_rules" {
  description = "Storage Account associated network rules."
  value       = one(azurerm_storage_account_network_rules.main)
}

output "module_storage_account" {
  description = "Storage Account module object."
  value       = module.storage
}
