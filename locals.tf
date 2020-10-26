locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  container_default_image = {
    // https://mcrflowprodcentralus.data.mcr.microsoft.com/mcrprod/azure-functions/base?P1=1603698941&P2=1&P3=1&P4=RkO8EgqoJ3TP7GjdC3jEm%2BmsXSK5kw1n0Q0UvWqRxAY%3D&se=2020-10-26T07%3A55%3A41Z&sig=pysHMJ9vr8bRk6DhWXdFHaZbxAxkVr8%2FzT2m%2Fu4YJ7I%3D&sp=r&sr=b&sv=2015-02-21
    2 = {
      python = "mcr.microsoft.com/azure-functions/python:2.0-python3.6"
      node   = "mcr.microsoft.com/azure-functions/node:2.0-node8"
      dotnet = "mcr.microsoft.com/azure-functions/dotnet:2.0"
    },
    3 = {
      python = "mcr.microsoft.com/azure-functions/python:3.0-python3.8"
      node   = "mcr.microsoft.com/azure-functions/node:3.0-node12"
      dotnet = "mcr.microsoft.com/azure-functions/dotnet:3.0"

    }
  }

  name_prefix          = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""
  ai_name_prefix       = var.application_insights_name_prefix != "" ? replace(var.application_insights_name_prefix, "/[a-z0-9]$/", "$0-") : local.name_prefix
  function_name_prefix = var.function_app_name_prefix != "" ? replace(var.function_app_name_prefix, "/[a-z0-9]$/", "$0-") : local.name_prefix
  sa_name_prefix       = var.storage_account_name_prefix != "" ? replace(var.storage_account_name_prefix, "/[a-z0-9]$/", "$0-") : local.name_prefix

  function_default_name             = "${local.function_name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-func"
  application_insights_default_name = "${local.ai_name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-ai"

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

  app_insights_instrumentation_key = var.application_insights_instrumentation_key != null ? var.application_insights_instrumentation_key : azurerm_application_insights.app_insights[0].instrumentation_key

  default_application_settings = {
    FUNCTIONS_WORKER_RUNTIME       = var.function_language_for_linux
    APPINSIGHTS_INSTRUMENTATIONKEY = local.app_insights_instrumentation_key
  }
}

