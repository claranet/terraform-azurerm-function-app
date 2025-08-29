output "linux_function_app" {
  description = "Linux Function App output object if Linux is chosen."
  value = lower(var.os_type) == "linux" ? {
    id                                          = azurerm_linux_function_app.main[0].id
    name                                        = azurerm_linux_function_app.main[0].name
    default_hostname                            = azurerm_linux_function_app.main[0].default_hostname
    outbound_ip_addresses                       = azurerm_linux_function_app.main[0].outbound_ip_addresses
    possible_outbound_ip_addresses              = azurerm_linux_function_app.main[0].possible_outbound_ip_addresses
    connection_string                           = azurerm_linux_function_app.main[0].connection_string
    identity_principal_id                       = try(azurerm_linux_function_app.main[0].identity[0].principal_id, null)
    resource                                    = azurerm_linux_function_app.main[0]
    module_diagnostics                          = module.diagnostics
    slot_name                                   = try(azurerm_linux_function_app_slot.staging[0].name, null)
    slot_default_hostname                       = try(azurerm_linux_function_app_slot.staging[0].default_hostname, null)
    slot_identity                               = try(azurerm_linux_function_app_slot.staging[0].identity[0], null)
    resource_slot                               = one(azurerm_linux_function_app_slot.staging[*])
    storage_account_id                          = local.storage_account.id
    storage_account_name                        = local.storage_account.name
    storage_account_primary_connection_string   = local.storage_account.primary_connection_string
    storage_account_primary_access_key          = local.storage_account.primary_access_key
    storage_account_secondary_connection_string = local.storage_account.secondary_connection_string
    storage_account_secondary_access_key        = local.storage_account.secondary_access_key
    storage_account_network_rules               = try(azurerm_storage_account_network_rules.main[0], null)
    application_insights_id                     = local.app_insights.id
    application_insights_name                   = local.app_insights.name
    application_insights_app_id                 = local.app_insights.app_id
    application_insights_instrumentation_key    = local.app_insights.instrumentation_key
    application_insights_application_type       = local.app_insights.application_type
    resource_application_insights               = local.app_insights
  } : null
}

output "windows_function_app" {
  description = "Windows Function App output object if Windows is chosen."
  value = lower(var.os_type) == "windows" ? {
    id                                          = azurerm_windows_function_app.main[0].id
    name                                        = azurerm_windows_function_app.main[0].name
    default_hostname                            = azurerm_windows_function_app.main[0].default_hostname
    outbound_ip_addresses                       = azurerm_windows_function_app.main[0].outbound_ip_addresses
    possible_outbound_ip_addresses              = azurerm_windows_function_app.main[0].possible_outbound_ip_addresses
    connection_string                           = azurerm_windows_function_app.main[0].connection_string
    identity_principal_id                       = try(azurerm_windows_function_app.main[0].identity[0].principal_id, null)
    resource                                    = azurerm_windows_function_app.main[0]
    module_diagnostics                          = module.diagnostics
    slot_name                                   = try(azurerm_windows_function_app_slot.staging[0].name, null)
    slot_default_hostname                       = try(azurerm_windows_function_app_slot.staging[0].default_hostname, null)
    slot_identity                               = try(azurerm_windows_function_app_slot.staging[0].identity[0], null)
    resource_slot                               = one(azurerm_windows_function_app_slot.staging[*])
    storage_account_id                          = local.storage_account.id
    storage_account_name                        = local.storage_account.name
    storage_account_primary_connection_string   = local.storage_account.primary_connection_string
    storage_account_primary_access_key          = local.storage_account.primary_access_key
    storage_account_secondary_connection_string = local.storage_account.secondary_connection_string
    storage_account_secondary_access_key        = local.storage_account.secondary_access_key
    storage_account_network_rules               = try(azurerm_storage_account_network_rules.main[0], null)
    application_insights_id                     = local.app_insights.id
    application_insights_name                   = local.app_insights.name
    application_insights_app_id                 = local.app_insights.app_id
    application_insights_instrumentation_key    = local.app_insights.instrumentation_key
    application_insights_application_type       = local.app_insights.application_type
    resource_application_insights               = local.app_insights
  } : null
}

output "flex_function_app" {
  description = "Flex Function App output object if flex is chosen."
  value = lower(var.os_type) == "flex" ? {
    id                                          = azurerm_function_app_flex_consumption.main[0].id
    name                                        = azurerm_function_app_flex_consumption.main[0].name
    default_hostname                            = azurerm_function_app_flex_consumption.main[0].default_hostname
    outbound_ip_addresses                       = azurerm_function_app_flex_consumption.main[0].outbound_ip_addresses
    possible_outbound_ip_addresses              = azurerm_function_app_flex_consumption.main[0].possible_outbound_ip_addresses
    connection_string                           = azurerm_function_app_flex_consumption.main[0].connection_string
    identity_principal_id                       = try(azurerm_function_app_flex_consumption.main[0].identity[0].principal_id, null)
    resource                                    = azurerm_function_app_flex_consumption.main[0]
    module_diagnostics                          = module.diagnostics
    slot_name                                   = null # Flex doesn't support slots
    slot_default_hostname                       = null # Flex doesn't support slots
    slot_identity                               = null # Flex doesn't support slots
    resource_slot                               = null # Flex doesn't support slots
    storage_account_id                          = local.storage_account.id
    storage_account_name                        = local.storage_account.name
    storage_account_primary_connection_string   = local.storage_account.primary_connection_string
    storage_account_primary_access_key          = local.storage_account.primary_access_key
    storage_account_secondary_connection_string = local.storage_account.secondary_connection_string
    storage_account_secondary_access_key        = local.storage_account.secondary_access_key
    storage_account_network_rules               = try(azurerm_storage_account_network_rules.main[0], null)
    application_insights_id                     = local.app_insights.id
    application_insights_name                   = local.app_insights.name
    application_insights_app_id                 = local.app_insights.app_id
    application_insights_instrumentation_key    = local.app_insights.instrumentation_key
    application_insights_application_type       = local.app_insights.application_type
    resource_application_insights               = local.app_insights
  } : null
}

output "id" {
  description = "ID of the created Function App."
  value       = local.function_output.id
}

output "name" {
  description = "Name of the created Function App."
  value       = local.function_output.name
}

output "default_hostname" {
  description = "Default hostname of the created Function App."
  value       = local.function_output.default_hostname
}

output "outbound_ip_addresses" {
  description = "Outbound IP adresses of the created Function App."
  value       = local.function_output.outbound_ip_addresses
}

output "possible_outbound_ip_addresses" {
  description = "All possible outbound IP adresses of the created Function App."
  value       = local.function_output.possible_outbound_ip_addresses
}

output "connection_string" {
  description = "Connection string of the created Function App."
  value       = local.function_output.connection_string
  sensitive   = true
}

output "identity_principal_id" {
  description = "Identity principal ID output of the Function App."
  value       = local.function_output.identity_principal_id
}

output "slot_name" {
  description = "Name of the Function App slot."
  value       = lower(var.os_type) == "linux" ? try(azurerm_linux_function_app_slot.staging[0].name, null) : lower(var.os_type) == "windows" ? try(azurerm_windows_function_app_slot.staging[0].name, null) : null
}

output "slot_default_hostname" {
  description = "Default hostname of the Function App slot."
  value       = lower(var.os_type) == "linux" ? try(azurerm_linux_function_app_slot.staging[0].default_hostname, null) : lower(var.os_type) == "windows" ? try(azurerm_windows_function_app_slot.staging[0].default_hostname, null) : null
}

output "slot_identity" {
  description = "Identity block output of the Function App slot."
  value       = lower(var.os_type) == "linux" ? try(azurerm_linux_function_app_slot.staging[0].identity[0], null) : lower(var.os_type) == "windows" ? try(azurerm_windows_function_app_slot.staging[0].identity[0], null) : null
}
