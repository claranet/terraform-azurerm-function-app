locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  container_default_image = {
    python = "microsoft/azure-functions-python3.6:2.0"
    node   = "microsoft/azure-functions-node8:2.0"
    dotnet = "microsoft/azure-functions-dotnet-core2.0:2.0"
  }

  name_prefix          = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""
  ai_name_prefix       = var.application_insights_name_prefix != "" ? replace(var.application_insights_name_prefix, "/[a-z0-9]$/", "$0-") : local.name_prefix
  function_name_prefix = var.function_app_name_prefix != "" ? replace(var.function_app_name_prefix, "/[a-z0-9]$/", "$0-") : local.name_prefix
  sa_name_prefix       = var.storage_account_name_prefix != "" ? replace(var.storage_account_name_prefix, "/[a-z0-9]$/", "$0-") : local.name_prefix

  storage_default_name_long = replace(
    format(
      "%s%s%s",
      local.sa_name_prefix,
      var.stack,
      var.environment,
    ),
    "/[._-]/",
    "",
  )
  storage_default_name = substr(
    local.storage_default_name_long,
    0,
    length(local.storage_default_name_long) > 24 ? 23 : -1,
  )

  storage_account_connection_string = coalesce(var.storage_account_connection_string, try(azurerm_storage_account.storage[0].primary_connection_string, ""))
  app_insights_instrumentation_key  = coalesce(var.application_insights_instrumentation_key, try(azurerm_application_insights.app_insights[0].instrumentation_key, ""))

  default_application_settings = {
    FUNCTIONS_WORKER_RUNTIME       = var.function_language_for_linux
    APPINSIGHTS_INSTRUMENTATIONKEY = local.app_insights_instrumentation_key
  }
}

