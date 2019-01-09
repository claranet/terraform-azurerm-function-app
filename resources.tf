# Storage account
resource "azurerm_storage_account" "storage" {
  name = "${local.storage_default_name}"

  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = "${merge(var.extra_tags, var.storage_account_extra_tags, local.default_tags)}"

  count = "${var.create_storage_account_resource == "true" ? 1 : 0}"
}

# Application Insights
resource "azurerm_application_insights" "app_insights" {
  name = "ai-${var.environment}-${var.location_short}-${var.client_name}-${var.stack}${coalesce(var.application_insights_name_suffix, var.name_suffix)}"

  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  application_type = "${var.application_insights_type}"

  tags = "${merge(var.extra_tags, var.application_insights_extra_tags, local.default_tags)}"

  count = "${var.create_application_insights_resource == "true" ? 1 : 0}"
}

# Function App
resource "azurerm_function_app" "function_app" {
  name = "func-${var.environment}-${var.location_short}-${var.client_name}-${var.stack}${coalesce(var.function_app_name_suffix, var.name_suffix)}"

  app_service_plan_id       = "${var.app_service_plan_id}"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  storage_connection_string = "${local.storage_account_connection_string}"

  app_settings = "${merge(local.default_application_settings, var.function_app_application_settings)}"

  tags = "${merge(var.extra_tags, var.function_app_extra_tags, local.default_tags)}"

  site_config {
    always_on = true
  }

  lifecycle {
    ignore_changes = [
      "app_settings.WEBSITE_RUN_FROM_ZIP",
      "app_settings.WEBSITE_RUN_FROM_PACKAGE",
      "app_settings.MACHINEKEY_DecryptionKey",
    ]
  }

  version = "~2"
}

# Force container configuration, mandatory for dedicated App Service Plans
# Temporary fix for issue https://github.com/terraform-providers/terraform-provider-azurerm/issues/1937
resource "null_resource" "container" {
  provisioner "local-exec" {
    command = <<SCRIPT
        az webapp config set --ids ${azurerm_function_app.function_app.id} --linux-fx-version "DOCKER|${lookup(local.container_default_image, var.function_language)}"
        az functionapp config appsettings delete --ids ${azurerm_function_app.function_app.id} --setting-names WEBSITES_ENABLE_APP_SERVICE_STORAGE
SCRIPT
  }

  depends_on = ["azurerm_function_app.function_app"]
}
