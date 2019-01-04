locals {
  default_tags = {
    env   = "${var.environment}"
    stack = "${var.stack}"
  }

  storage_default_name_long         = "${replace(format("st%s%s%s", var.environment, var.client_name, var.stack), "/[._-]/", "")}"
  storage_default_name              = "${substr(local.storage_default_name_long, 0, length(local.storage_default_name_long) > 24 ? 23 : -1)}"
  storage_account_connection_string = "${var.create_storage_account_resource == "true" ? join("", azurerm_storage_account.storage.*.primary_connection_string) : var.storage_account_connection_string}"

  app_insights_instrumentation_key = "${var.create_application_insights_resource == "true" ? join("", azurerm_application_insights.app_insights.*.instrumentation_key) : var.application_insights_instrumentation_key}"

  default_application_settings = {
    FUNCTIONS_WORKER_RUNTIME       = "${var.function_language}"
    APPINSIGHTS_INSTRUMENTATIONKEY = "${local.app_insights_instrumentation_key}"
  }
}
