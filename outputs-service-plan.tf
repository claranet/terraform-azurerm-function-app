output "service_plan_id" {
  description = "ID of the created Service Plan"
  value       = module.app_service_plan.service_plan_id
}

output "service_plan_name" {
  description = "Name of the created Service Plan"
  value       = module.app_service_plan.service_plan_name
}
