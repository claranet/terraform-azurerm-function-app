locals {
  # Naming locals/constants
  name_suffix = lower(var.name_suffix)
  name_prefix = lower(var.name_prefix)

  function_name_prefix = coalesce(var.function_app_name_prefix, local.name_prefix)
  ai_name_prefix       = coalesce(var.application_insights_name_prefix, local.name_prefix)
  sa_name_prefix       = coalesce(var.storage_account_name_prefix, local.name_prefix)

  app_insights_name    = coalesce(var.application_insights_custom_name, azurecaf_name.application_insights.name)
  function_app_name    = coalesce(var.function_app_custom_name, azurecaf_name.function_app.name)
  storage_account_name = coalesce(var.storage_account_name, azurecaf_name.storage_account.name)
}
