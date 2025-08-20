output "application_insights_id" {
  description = "ID of the associated Application Insights."
  value       = local.app_insights.id
}

output "application_insights_name" {
  description = "Name of the associated Application Insights."
  value       = local.app_insights.name
}

output "application_insights_app_id" {
  description = "App ID of the associated Application Insights."
  value       = local.app_insights.app_id
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key of the associated Application Insights."
  value       = local.app_insights.instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Connection string of the associated Application Insights."
  value       = local.app_insights.connection_string
  sensitive   = true
}
