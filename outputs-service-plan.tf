output "app_service_plan_id" {
  description = "ID of the created App Service Plan"
  value       = module.app_service_plan.app_service_plan_id
}

output "app_service_plan_name" {
  description = "Name of the created App Service Plan"
  value       = module.app_service_plan.app_service_plan_name
}
