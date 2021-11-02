# Data App Service Plan
data "azurerm_app_service_plan" "plan" {
  name                = element(split("/", var.app_service_plan_id), 8)
  resource_group_name = var.resource_group_name
}

# Function App
resource "azurerm_function_app" "function_app" {
  name = coalesce(var.function_app_custom_name, local.function_default_name)

  app_service_plan_id        = var.app_service_plan_id
  location                   = var.location
  resource_group_name        = var.resource_group_name
  storage_account_name       = var.storage_account_name == null ? local.storage_default_name : var.storage_account_name
  storage_account_access_key = var.storage_account_access_key == null ? azurerm_storage_account.storage[0].primary_access_key : var.storage_account_access_key
  os_type                    = var.os_type

  app_settings = merge(
    local.default_application_settings,
    var.function_app_application_settings,
  )

  dynamic "site_config" {
    for_each = [local.site_config]
    content {
      always_on                   = lookup(site_config.value, "always_on", null)
      ftps_state                  = lookup(site_config.value, "ftps_state", null)
      http2_enabled               = lookup(site_config.value, "http2_enabled", null)
      ip_restriction              = lookup(site_config.value, "ip_restriction", null)
      linux_fx_version            = lookup(site_config.value, "linux_fx_version", null)
      min_tls_version             = lookup(site_config.value, "min_tls_version", null)
      pre_warmed_instance_count   = lookup(site_config.value, "pre_warmed_instance_count", null)
      scm_use_main_ip_restriction = var.scm_authorized_ips != [] || var.scm_authorized_subnet_ids != null ? false : true
      scm_ip_restriction          = concat(local.scm_subnets, local.scm_cidrs, local.scm_service_tags)
      scm_type                    = lookup(site_config.value, "scm_type", null)
      use_32_bit_worker_process   = lookup(site_config.value, "use_32_bit_worker_process", null)
      websockets_enabled          = lookup(site_config.value, "websockets_enabled", null)

      dynamic "cors" {
        for_each = lookup(site_config.value, "cors", []) != [] ? ["fake"] : []
        content {
          allowed_origins     = lookup(site_config.value.cors, "allowed_origins", [])
          support_credentials = lookup(site_config.value.cors, "support_credentials", false)
        }
      }
    }
  }

  https_only = var.https_only

  lifecycle {
    ignore_changes = [
      app_settings.WEBSITE_RUN_FROM_ZIP,
      app_settings.WEBSITE_RUN_FROM_PACKAGE,
      app_settings.MACHINEKEY_DecryptionKey,
      app_settings.WEBSITE_CONTENTAZUREFILECONNECTIONSTRING,
      app_settings.WEBSITE_CONTENTSHARE
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

resource "azurerm_app_service_virtual_network_swift_connection" "function_vnet_integration" {
  count = var.function_app_vnet_integration_enabled ? 1 : 0

  app_service_id = azurerm_function_app.function_app.id
  subnet_id      = var.function_app_vnet_integration_subnet_id
}
