output "service_plan_id" {
  description = "ID of the created Service Plan."
  value       = module.service_plan.id
}

output "service_plan_name" {
  description = "Name of the created Service Plan."
  value       = module.service_plan.name
}

output "os_type" {
  description = "The OS type for the Functions to be hosted in this plan."
  value       = var.os_type
}

output "module_service_plan" {
  description = "Service Plan module object."
  value       = module.service_plan
}
