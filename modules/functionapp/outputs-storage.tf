output "storage_account_id" {
  description = "ID of the associated Storage Account, empty if connection string provided"
  value       = join("", azurerm_storage_account.storage[*].id)
}

output "storage_account_name" {
  description = "Name of the associated Storage Account, empty if connection string provided"
  value       = join("", azurerm_storage_account.storage[*].name)
}

output "storage_account_primary_connection_string" {
  description = "Primary connection string of the associated Storage Account, empty if connection string provided"
  value = join(
    "",
    azurerm_storage_account.storage[*].primary_connection_string,
  )
  sensitive = true
}

output "storage_account_primary_access_key" {
  description = "Primary connection string of the associated Storage Account, empty if connection string provided"
  value       = join("", azurerm_storage_account.storage[*].primary_access_key)
  sensitive   = true
}

output "storage_account_secondary_connection_string" {
  description = "Secondary connection string of the associated Storage Account, empty if connection string provided"
  value = join(
    "",
    azurerm_storage_account.storage[*].secondary_connection_string,
  )
  sensitive = true
}

output "storage_account_secondary_access_key" {
  description = "Secondary connection string of the associated Storage Account, empty if connection string provided"
  value       = join("", azurerm_storage_account.storage[*].secondary_access_key)
  sensitive   = true
}

output "storage_account_network_rules" {
  description = "Network rules of the associated Storage Account"
  value       = var.storage_account_access_key == null && var.storage_account_network_rules_enabled ? azurerm_storage_account_network_rules.storage_network_rules["enabled"] : null
}
