# Data App Service Plan
data "azurerm_app_service_plan" "plan" {
  name                = element(split("/", var.app_service_plan_id), 8)
  resource_group_name = var.resource_group_name
}

# Storage account
resource "azurerm_storage_account" "storage" {
  name = local.storage_default_name

  location            = var.location
  resource_group_name = var.resource_group_name

  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = merge(
    local.default_tags,
    var.storage_account_extra_tags,
    var.extra_tags,
  )

  count = var.create_storage_account_resource == "true" ? 1 : 0
}

# Application Insights
resource "azurerm_application_insights" "app_insights" {
  name = "${local.ai_name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-ai"

  location            = var.location
  resource_group_name = var.resource_group_name

  application_type = var.application_insights_type

  tags = merge(
    local.default_tags,
    var.application_insights_extra_tags,
    var.extra_tags,
  )

  count = var.create_application_insights_resource == "true" ? 1 : 0
}

# Function App
resource "azurerm_function_app" "function_app" {
  name = "${local.function_name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-func"

  app_service_plan_id       = var.app_service_plan_id
  location                  = var.location
  resource_group_name       = var.resource_group_name
  storage_connection_string = local.storage_account_connection_string

  app_settings = merge(
    local.default_application_settings,
    var.function_app_application_settings,
  )

  site_config {
    always_on = replace(
      jsonencode(data.azurerm_app_service_plan.plan.sku),
      "/.*Dynamic.*/",
      "dummy",
    ) == "dummy" ? false : true
    linux_fx_version = "DOCKER|${local.container_default_image[var.function_language_for_linux]}"
  }

  lifecycle {
    ignore_changes = [
      app_settings.WEBSITE_RUN_FROM_ZIP,
      app_settings.WEBSITE_RUN_FROM_PACKAGE,
      app_settings.MACHINEKEY_DecryptionKey,
    ]
  }

  version = "~2"
}

