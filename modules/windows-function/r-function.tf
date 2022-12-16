# Data Service Plan
data "azurerm_service_plan" "plan" {
  name                = element(split("/", var.service_plan_id), 8)
  resource_group_name = var.resource_group_name
}

# Function App
resource "azurerm_windows_function_app" "windows_function" {
  name = local.function_app_name

  service_plan_id     = var.service_plan_id
  location            = var.location
  resource_group_name = var.resource_group_name

  storage_account_name       = local.storage_account_name
  storage_account_access_key = var.storage_account_access_key == null ? local.storage_account_output.primary_access_key : var.storage_account_access_key
  # storage_uses_managed_identity = 
  # storage_key_vault_secret_id =

  functions_extension_version = "~${var.function_app_version}"

  virtual_network_subnet_id = var.function_app_vnet_integration_subnet_id

  app_settings = merge(
    local.default_application_settings,
    var.function_app_application_settings,
  )

  dynamic "site_config" {
    for_each = [local.site_config]
    content {
      always_on                         = lookup(site_config.value, "always_on", null)
      api_definition_url                = lookup(site_config.value, "api_definition_url", null)
      api_management_api_id             = lookup(site_config.value, "api_management_api_id", null)
      app_command_line                  = lookup(site_config.value, "app_command_line", null)
      app_scale_limit                   = lookup(site_config.value, "app_scale_limit", null)
      default_documents                 = lookup(site_config.value, "default_documents", null)
      ftps_state                        = lookup(site_config.value, "ftps_state", "Disabled")
      health_check_path                 = lookup(site_config.value, "health_check_path", null)
      health_check_eviction_time_in_min = lookup(site_config.value, "health_check_eviction_time_in_min", null)
      http2_enabled                     = lookup(site_config.value, "http2_enabled", null)
      load_balancing_mode               = lookup(site_config.value, "load_balancing_mode", null)
      managed_pipeline_mode             = lookup(site_config.value, "managed_pipeline_mode", null)
      minimum_tls_version               = lookup(site_config.value, "minimum_tls_version", lookup(site_config.value, "min_tls_version", "1.2"))
      remote_debugging_enabled          = lookup(site_config.value, "remote_debugging_enabled", false)
      remote_debugging_version          = lookup(site_config.value, "remote_debugging_version", null)
      runtime_scale_monitoring_enabled  = lookup(site_config.value, "runtime_scale_monitoring_enabled", null)
      websockets_enabled                = lookup(site_config.value, "websockets_enabled", false)

      pre_warmed_instance_count = lookup(site_config.value, "pre_warmed_instance_count", null)
      elastic_instance_minimum  = lookup(site_config.value, "elastic_instance_minimum", null)
      worker_count              = lookup(site_config.value, "worker_count", null)

      vnet_route_all_enabled = lookup(site_config.value, "vnet_route_all_enabled", var.function_app_vnet_integration_subnet_id != null)

      ip_restriction              = concat(local.subnets, local.cidrs, local.service_tags)
      scm_type                    = lookup(site_config.value, "scm_type", null)
      scm_use_main_ip_restriction = length(var.scm_authorized_ips) > 0 || var.scm_authorized_subnet_ids != null ? false : true
      scm_ip_restriction          = concat(local.scm_subnets, local.scm_cidrs, local.scm_service_tags)

      dynamic "application_stack" {
        for_each = lookup(site_config.value, "application_stack", null) == null ? [] : ["application_stack"]
        content {
          dotnet_version              = lookup(local.site_config.application_stack, "dotnet_version", null)
          use_dotnet_isolated_runtime = lookup(local.site_config.application_stack, "use_dotnet_isolated_runtime", null)

          java_version            = lookup(local.site_config.application_stack, "java_version", null)
          node_version            = lookup(local.site_config.application_stack, "node_version", null)
          powershell_core_version = lookup(local.site_config.application_stack, "powershell_core_version", null)

          use_custom_runtime = lookup(local.site_config.application_stack, "use_custom_runtime", null)
        }
      }

      dynamic "cors" {
        for_each = lookup(site_config.value, "cors", null) != null ? ["cors"] : []
        content {
          allowed_origins     = lookup(site_config.value.cors, "allowed_origins", [])
          support_credentials = lookup(site_config.value.cors, "support_credentials", false)
        }
      }
    }
  }

  https_only                 = var.https_only
  client_certificate_enabled = var.client_certificate_enabled
  client_certificate_mode    = var.client_certificate_mode
  builtin_logging_enabled    = var.builtin_logging_enabled

  lifecycle {
    ignore_changes = [
      app_settings.WEBSITE_RUN_FROM_ZIP,
      app_settings.WEBSITE_RUN_FROM_PACKAGE,
      app_settings.MACHINEKEY_DecryptionKey,
      app_settings.WEBSITE_CONTENTAZUREFILECONNECTIONSTRING,
      app_settings.WEBSITE_CONTENTSHARE,
    ]
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? ["identity"] : []
    content {
      type = var.identity_type
      # Avoid perpetual changes if SystemAssigned and identity_ids is not null
      identity_ids = var.identity_type == "UserAssigned" ? var.identity_ids : null
    }
  }

  tags = merge(var.extra_tags, var.function_app_extra_tags, local.default_tags)
}

resource "azurerm_windows_function_app_slot" "windows_function_slot" {
  count = var.staging_slot_enabled ? 1 : 0

  name            = local.staging_slot_name
  function_app_id = azurerm_windows_function_app.windows_function.id

  storage_account_name       = local.storage_account_name
  storage_account_access_key = var.storage_account_access_key == null ? local.storage_account_output.primary_access_key : var.storage_account_access_key

  functions_extension_version = "~${var.function_app_version}"

  virtual_network_subnet_id = var.function_app_vnet_integration_subnet_id

  app_settings = var.staging_slot_custom_application_settings == null ? var.function_app_application_settings : var.staging_slot_custom_application_settings

  dynamic "site_config" {
    for_each = [local.site_config]
    content {
      always_on                         = lookup(site_config.value, "always_on", null)
      api_definition_url                = lookup(site_config.value, "api_definition_url", null)
      api_management_api_id             = lookup(site_config.value, "api_management_api_id", null)
      app_command_line                  = lookup(site_config.value, "app_command_line", null)
      app_scale_limit                   = lookup(site_config.value, "app_scale_limit", null)
      default_documents                 = lookup(site_config.value, "default_documents", null)
      ftps_state                        = lookup(site_config.value, "ftps_state", "Disabled")
      health_check_path                 = lookup(site_config.value, "health_check_path", null)
      health_check_eviction_time_in_min = lookup(site_config.value, "health_check_eviction_time_in_min", null)
      http2_enabled                     = lookup(site_config.value, "http2_enabled", null)
      load_balancing_mode               = lookup(site_config.value, "load_balancing_mode", null)
      managed_pipeline_mode             = lookup(site_config.value, "managed_pipeline_mode", null)
      minimum_tls_version               = lookup(site_config.value, "minimum_tls_version", lookup(site_config.value, "min_tls_version", "1.2"))
      remote_debugging_enabled          = lookup(site_config.value, "remote_debugging_enabled", false)
      remote_debugging_version          = lookup(site_config.value, "remote_debugging_version", null)
      runtime_scale_monitoring_enabled  = lookup(site_config.value, "runtime_scale_monitoring_enabled", null)
      websockets_enabled                = lookup(site_config.value, "websockets_enabled", false)

      pre_warmed_instance_count = lookup(site_config.value, "pre_warmed_instance_count", null)
      elastic_instance_minimum  = lookup(site_config.value, "elastic_instance_minimum", null)
      worker_count              = lookup(site_config.value, "worker_count", null)

      vnet_route_all_enabled = lookup(site_config.value, "vnet_route_all_enabled", var.function_app_vnet_integration_subnet_id != null)

      ip_restriction              = concat(local.subnets, local.cidrs, local.service_tags)
      scm_type                    = lookup(site_config.value, "scm_type", null)
      scm_use_main_ip_restriction = length(var.scm_authorized_ips) > 0 || var.scm_authorized_subnet_ids != null ? false : true
      scm_ip_restriction          = concat(local.scm_subnets, local.scm_cidrs, local.scm_service_tags)

      dynamic "application_stack" {
        for_each = lookup(site_config.value, "application_stack", null) == null ? [] : ["application_stack"]
        content {
          dotnet_version              = lookup(local.site_config.application_stack, "dotnet_version", null)
          use_dotnet_isolated_runtime = lookup(local.site_config.application_stack, "use_dotnet_isolated_runtime", null)

          java_version            = lookup(local.site_config.application_stack, "java_version", null)
          node_version            = lookup(local.site_config.application_stack, "node_version", null)
          powershell_core_version = lookup(local.site_config.application_stack, "powershell_core_version", null)

          use_custom_runtime = lookup(local.site_config.application_stack, "use_custom_runtime", null)
        }
      }

      dynamic "cors" {
        for_each = lookup(site_config.value, "cors", null) != null ? ["cors"] : []
        content {
          allowed_origins     = lookup(site_config.value.cors, "allowed_origins", [])
          support_credentials = lookup(site_config.value.cors, "support_credentials", false)
        }
      }
    }
  }

  https_only              = var.https_only
  builtin_logging_enabled = var.builtin_logging_enabled

  lifecycle {
    ignore_changes = [
      app_settings.WEBSITE_RUN_FROM_ZIP,
      app_settings.WEBSITE_RUN_FROM_PACKAGE,
      app_settings.MACHINEKEY_DecryptionKey,
      app_settings.WEBSITE_CONTENTAZUREFILECONNECTIONSTRING,
      app_settings.WEBSITE_CONTENTSHARE,
    ]
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? ["identity"] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? var.identity_ids : null
    }
  }

  tags = merge(var.extra_tags, var.function_app_extra_tags, local.default_tags)
}
