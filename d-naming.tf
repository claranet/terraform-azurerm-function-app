# Naming data sources consolidated from submodules

data "azurecaf_name" "function_app" {
  name          = var.stack
  resource_type = "azurerm_function_app"
  prefixes      = local.function_app_name_prefix == "" ? null : [local.function_app_name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "application_insights" {
  name          = var.stack
  resource_type = "azurerm_application_insights"
  prefixes      = local.application_insights_name_prefix == "" ? null : [local.application_insights_name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}
