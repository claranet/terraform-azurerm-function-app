output "service_plan_id" {
  description = "ID of the Service Plan (created or existing)."
  value       = local.service_plan_resource.id
}

output "service_plan_name" {
  description = "Name of the Service Plan (created or existing)."
  value       = local.service_plan_resource.name
}

output "module_service_plan" {
  description = "Service Plan module object. `null` when using an existing Service Plan."
  value       = var.service_plan == null ? module.service_plan[0] : null
}
