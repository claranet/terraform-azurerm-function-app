output "app_service_plan_id" {
  description = "Id of the created App Service Plan"
  value       = "${module.app_service_plan.app_service_plan_id}"
}

output "app_service_plan_name" {
  description = "Name of the created App Service Plan"
  value       = "${module.app_service_plan.app_service_plan_name}"
}

output "storage_account_id" {
  description = "Id of the associated Storage Account, empty if connection string provided"
  value       = "${join("", azurerm_storage_account.storage.*.id)}"
}

output "storage_account_name" {
  description = "Name of the associated Storage Account, empty if connection string provided"
  value       = "${join("", azurerm_storage_account.storage.*.name)}"
}

output "storage_account_primary_connection_string" {
  description = "Primary connection string of the associated Storage Account, empty if connection string provided"
  value       = "${join("", azurerm_storage_account.storage.*.primary_connection_string)}"
  sensitive   = true
}

output "storage_account_primary_access_key" {
  description = "Primary connection string of the associated Storage Account, empty if connection string provided"
  value       = "${join("", azurerm_storage_account.storage.*.primary_access_key)}"
  sensitive   = true
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation of the associated Application Insights"
  value       = "${local.app_insights_instrumentation_key}"
  sensitive   = true
}

output "function_app_id" {
  description = "Id of the created Function App"
  value       = "${azurerm_function_app.function_app.id}"
}

output "function_app_name" {
  description = "Name of the created Function App"
  value       = "${azurerm_function_app.function_app.name}"
}

output "function_app_outbound_ip_addresses" {
  description = "Outbound IP adresses of the created Function App"
  value       = "${azurerm_function_app.function_app.outbound_ip_addresses}"
}

output "function_app_connection_string" {
  description = "Connection string of the created Function App"
  value       = "${azurerm_function_app.function_app.connection_string}"
  sensitive   = true
}
