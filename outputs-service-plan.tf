output "service_plan_id" {
  description = "ID of the created Service Plan"
  value       = module.service_plan.service_plan_id
}

output "service_plan_name" {
  description = "Name of the created Service Plan"
  value       = module.service_plan.service_plan_name
}

output "os_type" {
  description = "The OS type for the Functions to be hosted in this plan."
  value       = var.os_type
}
