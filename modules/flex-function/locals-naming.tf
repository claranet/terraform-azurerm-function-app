locals {
  # Naming locals/constants
  name_suffix = lower(var.name_suffix)
  name_prefix = lower(var.name_prefix)

  function_app_name_prefix         = var.function_app_name_prefix == "" ? local.name_prefix : lower(var.function_app_name_prefix)
  application_insights_name_prefix = var.application_insights_name_prefix == "" ? local.name_prefix : lower(var.application_insights_name_prefix)
  storage_account_name_prefix      = var.storage_account_name_prefix == "" ? local.name_prefix : lower(var.storage_account_name_prefix)

  app_insights_name = coalesce(var.application_insights_custom_name, data.azurecaf_name.application_insights.result)
  function_app_name = coalesce(var.custom_name, data.azurecaf_name.function_app.result)
}
