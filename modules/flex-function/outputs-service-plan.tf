output "service_plan_id" {
  description = "ID of the associated Service Plan."
  value       = data.azurerm_service_plan.main.id
}

output "service_plan_name" {
  description = "Name of the associated Service Plan."
  value       = data.azurerm_service_plan.main.name
}

output "service_plan_sku_name" {
  description = "SKU name of the associated Service Plan."
  value       = data.azurerm_service_plan.main.sku_name
}

output "service_plan_os_type" {
  description = "OS type of the associated Service Plan."
  value       = data.azurerm_service_plan.main.os_type
}
