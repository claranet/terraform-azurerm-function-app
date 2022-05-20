output "application_insights_id" {
  description = "ID of the associated Application Insights"
  value       = try(local.app_insights.id, null)
}

output "application_insights_name" {
  description = "Name of the associated Application Insights"
  value       = try(local.app_insights.name, null)
}

output "application_insights_app_id" {
  description = "App ID of the associated Application Insights"
  value       = try(local.app_insights.app_id, null)
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key of the associated Application Insights"
  value       = try(local.app_insights.instrumentation_key, null)
  sensitive   = true
}

output "application_insights_application_type" {
  description = "Application Type of the associated Application Insights"
  value       = try(local.app_insights.application_type, null)
}
