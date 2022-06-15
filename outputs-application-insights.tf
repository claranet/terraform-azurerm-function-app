output "application_insights_id" {
  description = "ID of the associated Application Insights"
  value       = local.function_output.application_insights_id
}

output "application_insights_name" {
  description = "Name of the associated Application Insights"
  value       = local.function_output.application_insights_name
}

output "application_insights_app_id" {
  description = "App ID of the associated Application Insights"
  value       = local.function_output.application_insights_app_id
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key of the associated Application Insights"
  value       = local.function_output.application_insights_instrumentation_key
  sensitive   = true
}

output "application_insights_application_type" {
  description = "Application Type of the associated Application Insights"
  value       = local.function_output.application_insights_application_type
}
