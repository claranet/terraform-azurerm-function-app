# App Service Plan
module "app_service_plan" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/app-service-plan.git?ref=TER-313-app_service_plan_module"

  client_name         = "${var.client_name}"
  environment         = "${var.environment}"
  stack               = "${var.stack}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  location_short      = "${var.location_short}"
  name_suffix         = "-${var.short_name}"

  sku = {
    size = "Y1"
    tier = "Dynamic"
  }

  #kind = "${lookup(local.app_service_kind_map, var.function_language, "Linux")}"
  kind = "FunctionApp"

  extra_tags = "${merge(var.extra_tags, var.app_service_plan_extra_tags, local.default_tags)}"
}

# Storage account
resource "azurerm_storage_account" "storage" {
  name = "${local.storage_default_name}"

  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = "${merge(var.extra_tags, var.storage_account_extra_tags, local.default_tags)}"

  count = "${var.storage_account_connection_string == "" ? 1 : 0}"
}

# Application Insights
resource "azurerm_application_insights" "app_insights" {
  name = "ai-${var.environment}-${var.location_short}-${var.client_name}-${var.stack}"

  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  application_type = "${var.application_insights_type}"

  tags = "${merge(var.extra_tags, var.application_insights_extra_tags, local.default_tags)}"

  count = "${var.application_insights_instrumentation_key == "" ? 1 : 0}"
}

# Function App
resource "azurerm_function_app" "function_app" {
  name = "func-${var.environment}-${var.location_short}-${var.client_name}-${var.stack}-${var.short_name}"

  app_service_plan_id       = "${module.app_service_plan.app_service_plan_id}"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  storage_connection_string = "${local.storage_account_connection_string}"

  app_settings = "${merge(local.default_application_settings, var.function_app_application_settings)}"

  tags = "${merge(var.extra_tags, var.function_app_extra_tags, local.default_tags)}"

  lifecycle {
    ignore_changes = [
      "app_settings.WEBSITE_RUN_FROM_ZIP",
      "app_settings.WEBSITE_RUN_FROM_PACKAGE",
    ]
  }
}
