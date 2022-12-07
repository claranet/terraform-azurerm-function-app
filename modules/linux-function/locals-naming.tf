locals {
  # Naming locals/constants
  name_suffix = lower(var.name_suffix)
  name_prefix = lower(var.name_prefix)

  function_name_prefix = var.function_app_name_prefix == "" ? local.name_prefix : lower(var.function_app_name_prefix)
  ai_name_prefix       = var.application_insights_name_prefix == "" ? local.name_prefix : lower(var.application_insights_name_prefix)
  sa_name_prefix       = var.storage_account_name_prefix == "" ? local.name_prefix : lower(var.storage_account_name_prefix)

  app_insights_name    = coalesce(var.application_insights_custom_name, data.azurecaf_name.application_insights.result)
  function_app_name    = coalesce(var.function_app_custom_name, data.azurecaf_name.function_app.result)
  staging_slot_name    = coalesce(var.staging_slot_custom_name, "staging-slot")
  storage_account_name = coalesce(var.storage_account_name, data.azurecaf_name.storage_account.result)
}
