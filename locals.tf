locals {
  default_tags = {
    env   = "${var.environment}"
    stack = "${var.stack}"
  }

  container_default_image = {
    python = "microsoft/azure-functions-python3.6:2.0"
    node   = "microsoft/azure-functions-node8:2.0"
    dotnet = "microsoft/azure-functions-dotnet-core2.0:2.0"
  }

  name_prefix          = "${var.name_prefix != "" ? format("%s-", var.name_prefix) : ""}"
  ai_name_prefix       = "${var.application_insights_name_prefix != "" ? format("%s-", var.application_insights_name_prefix) : local.name_prefix}"
  function_name_prefix = "${var.function_app_name_prefix != "" ? format("%s-", var.function_app_name_prefix) : local.name_prefix}"

  storage_default_name_long         = "${replace(format("%s%s%s", coalesce(var.storage_account_name_prefix, var.name_prefix), var.stack, var.environment), "/[._-]/", "")}"
  storage_default_name              = "${substr(local.storage_default_name_long, 0, length(local.storage_default_name_long) > 24 ? 23 : -1)}"
  storage_account_connection_string = "${var.create_storage_account_resource == "true" ? join("", azurerm_storage_account.storage.*.primary_connection_string) : var.storage_account_connection_string}"

  app_insights_instrumentation_key = "${var.create_application_insights_resource == "true" ? join("", azurerm_application_insights.app_insights.*.instrumentation_key) : var.application_insights_instrumentation_key}"

  default_application_settings = {
    FUNCTIONS_WORKER_RUNTIME       = "${var.function_language_for_linux}"
    APPINSIGHTS_INSTRUMENTATIONKEY = "${local.app_insights_instrumentation_key}"
  }
}
