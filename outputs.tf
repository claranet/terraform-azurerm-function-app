output "linux_function_app" {
  description = "Linux Function App output object if Linux is chosen. Please refer to `./modules/linux-function/README.md`"
  value       = one(module.linux_function[*])
}

output "windows_function_app" {
  description = "Windows Function App output object if Windows is chosen. Please refer to `./modules/windows-function/README.md`"
  value       = one(module.windows_function[*])
}

output "id" {
  description = "ID of the created Function App."
  value       = local.function_output.function_app_id
}

output "name" {
  description = "Name of the created Function App."
  value       = local.function_output.function_app_name
}

output "default_hostname" {
  description = "Default hostname of the created Function App."
  value       = local.function_output.function_app_default_hostname
}

output "outbound_ip_addresses" {
  description = "Outbound IP adresses of the created Function App."
  value       = local.function_output.function_app_outbound_ip_addresses
}

output "possible_outbound_ip_addresses" {
  description = "All possible outbound IP adresses of the created Function App."
  value       = local.function_output.function_app_possible_outbound_ip_addresses
}

output "connection_string" {
  description = "Connection string of the created Function App."
  value       = local.function_output.function_app_connection_string
  sensitive   = true
}

output "identity" {
  description = "Identity block output of the Function App."
  value       = local.function_output.function_app_identity
}

output "slot_name" {
  description = "Name of the Function App slot."
  value       = local.function_output.function_app_slot_name
}

output "slot_default_hostname" {
  description = "Default hostname of the Function App slot."
  value       = local.function_output.function_app_slot_default_hostname
}

output "slot_identity" {
  description = "Identity block output of the Function App slot."
  value       = local.function_output.function_app_slot_identity
}
