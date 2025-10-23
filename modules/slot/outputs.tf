output "slot" {
  description = "Azure Function App slot output object."
  value = coalesce(
    one(azurerm_linux_function_app_slot.main[*]),
    one(azurerm_windows_function_app_slot.main[*]),
  )
}

output "id" {
  description = "Azure Function App slot ID."
  value = coalesce(
    one(azurerm_linux_function_app_slot.main[*].id),
    one(azurerm_windows_function_app_slot.main[*].id),
  )
}

output "name" {
  description = "Azure Function App slot name."
  value = coalesce(
    one(azurerm_linux_function_app_slot.main[*].name),
    one(azurerm_windows_function_app_slot.main[*].name),
    lower(var.slot_os_type) == "flex" ? var.name : null
  )
}

output "default_hostname" {
  description = "Default hostname of the Function App slot."
  value = coalesce(
    one(azurerm_linux_function_app_slot.main[*].default_hostname),
    one(azurerm_windows_function_app_slot.main[*].default_hostname),
  )
}

output "identity_principal_id" {
  description = "Azure Function App slot system identity principal ID."
  value = coalesce(
    try(azurerm_linux_function_app_slot.main[0].identity[0].principal_id, null),
    try(azurerm_windows_function_app_slot.main[0].identity[0].principal_id, null),
  )
}

output "outbound_ip_addresses" {
  description = "Outbound IP addresses of the Function App slot."
  value = coalesce(
    one(azurerm_linux_function_app_slot.main[*].outbound_ip_addresses),
    one(azurerm_windows_function_app_slot.main[*].outbound_ip_addresses),
  )
}

output "possible_outbound_ip_addresses" {
  description = "All possible outbound IP addresses of the Function App slot."
  value = coalesce(
    one(azurerm_linux_function_app_slot.main[*].possible_outbound_ip_addresses),
    one(azurerm_windows_function_app_slot.main[*].possible_outbound_ip_addresses),
  )
}
