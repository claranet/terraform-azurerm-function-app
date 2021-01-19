output "app_service_plan_id" {
  description = "Id of the created App Service Plan"
  value       = var.app_service_plan_id
}

output "storage_account_id" {
  description = "Id of the associated Storage Account, empty if connection string provided"
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
    azurerm_storage_account.storage.*.secondary_connection_string,
  )
  sensitive = true
}

output "storage_account_secondary_access_key" {
  description = "Secondary connection string of the associated Storage Account, empty if connection string provided"
  value       = join("", azurerm_storage_account.storage.*.secondary_access_key)
  sensitive   = true
}

output "application_insights_id" {
  description = "Id of the associated Application Insights"
  value       = try(local.app_insights.id, null)
}

output "application_insights_name" {
  description = "Name of the associated Application Insights"
  value       = try(local.app_insights.name, null)
}

output "application_insights_app_id" {
  description = "App id of the associated Application Insights"
  value       = try(local.app_insights.app_id, null)
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key of the associated Application Insights"
  value       = try(local.app_insights.instrumentation_key, null)
  sensitive   = true
}

output "app_insights_application_type" {
  description = "Application Type of the associated Application Insights"
  value       = try(local.app_insights.application_type, null)
}

output "function_app_id" {
  description = "Id of the created Function App"
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

output "function_app_connection_string" {
  description = "Connection string of the created Function App"
  value       = azurerm_function_app.function_app.connection_string
  sensitive   = true
}

output "function_app_identity" {
  value       = azurerm_function_app.function_app.identity
  description = "Identity block output of the Function App"
}
