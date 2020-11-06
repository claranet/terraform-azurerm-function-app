# Data App Service Plan
data "azurerm_app_service_plan" "plan" {
  name                = element(split("/", var.app_service_plan_id), 8)
  resource_group_name = var.resource_group_name
}

# Storage account
resource "azurerm_storage_account" "storage" {
  name = coalesce(var.storage_account_name, local.storage_default_name)

  location            = var.location
  resource_group_name = var.resource_group_name

  account_replication_type = "LRS"
  account_tier             = "Standard"
  account_kind             = var.storage_account_kind

  enable_https_traffic_only = var.storage_account_enable_https_traffic_only

  tags = merge(
    local.default_tags,
    var.storage_account_extra_tags,
    var.extra_tags,
  )

  count = var.storage_account_primary_access_key == null ? 1 : 0
}

resource "azurerm_advanced_threat_protection" "threat_protection" {
  count              = var.storage_account_primary_access_key == null ? 1 : 0
  enabled            = var.storage_account_enable_advanced_threat_protection
  target_resource_id = azurerm_storage_account.storage[0].id
}

# Application Insights
resource "azurerm_application_insights" "app_insights" {
  name = coalesce(var.application_insights_custom_name, local.application_insights_default_name)

  location            = var.location
  resource_group_name = var.resource_group_name

  application_type = var.application_insights_type

  tags = merge(
    local.default_tags,
    var.application_insights_extra_tags,
    var.extra_tags,
  )

  count = var.application_insights_instrumentation_key == null ? 1 : 0
}

# Function App
resource "azurerm_function_app" "function_app" {
  name = coalesce(var.function_app_custom_name, local.function_default_name)

  app_service_plan_id        = var.app_service_plan_id
  location                   = var.location
  resource_group_name        = var.resource_group_name
  storage_account_name       = var.storage_account_name == null ? local.storage_default_name : var.storage_account_name
  storage_account_access_key = var.storage_account_primary_access_key == null ? azurerm_storage_account.storage[0].primary_access_key : var.storage_account_primary_access_key
  os_type                    = var.os_type

  app_settings = merge(
    local.default_application_settings,
    var.function_app_application_settings,
  )

  site_config {

    always_on        = data.azurerm_app_service_plan.plan.sku[0].tier == "Dynamic" ? false : true
    linux_fx_version = "%{if data.azurerm_app_service_plan.plan.kind == "linux"}DOCKER|${local.container_default_image[var.function_app_version][var.function_language_for_linux]}%{else}%{endif}"
    ip_restriction   = concat(local.subnets, local.cidrs)
  }

  lifecycle {
    ignore_changes = [
      app_settings.WEBSITE_RUN_FROM_ZIP,
      app_settings.WEBSITE_RUN_FROM_PACKAGE,
      app_settings.MACHINEKEY_DecryptionKey,
    ]
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? ["fake"] : []
    content {
      type = var.identity_type
      # Avoid perpetual changes if SystemAssigned and identity_ids is not null
      identity_ids = var.identity_type == "UserAssigned" ? var.identity_ids : null
    }
  }

  version = "~${var.function_app_version}"

  tags = merge(var.extra_tags, var.function_app_extra_tags, local.default_tags)
}
