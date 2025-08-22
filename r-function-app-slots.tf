# Function App Staging Slots (Linux and Windows only)
resource "azurerm_linux_function_app_slot" "staging" {
  count = lower(var.os_type) == "linux" && var.staging_slot_enabled ? 1 : 0

  name            = local.staging_slot_name
  function_app_id = azurerm_linux_function_app.main[0].id

  storage_account_name          = local.storage_account.name
  storage_account_access_key    = !var.storage_uses_managed_identity ? local.storage_account.primary_access_key : null
  storage_uses_managed_identity = var.storage_uses_managed_identity ? true : null

  functions_extension_version = "~${var.function_app_version}"

  public_network_access_enabled = var.public_network_access_enabled
  virtual_network_subnet_id     = var.vnet_integration_subnet_id

  app_settings = var.staging_slot_custom_application_settings == null ? {
    for k, v in merge(local.default_application_settings, var.application_settings) : k => v if k != "WEBSITE_RUN_FROM_PACKAGE"
    } : {
    for k, v in merge(local.default_application_settings, var.staging_slot_custom_application_settings) : k => v if k != "WEBSITE_RUN_FROM_PACKAGE"
  }

  # Same site_config as main app
  dynamic "site_config" {
    for_each = [local.site_config]
    content {
      always_on                         = site_config.value.always_on
      api_definition_url                = site_config.value.api_definition_url
      api_management_api_id             = site_config.value.api_management_api_id
      app_command_line                  = site_config.value.app_command_line
      app_scale_limit                   = site_config.value.app_scale_limit
      default_documents                 = site_config.value.default_documents
      ftps_state                        = site_config.value.ftps_state
      health_check_path                 = site_config.value.health_check_path
      health_check_eviction_time_in_min = site_config.value.health_check_eviction_time_in_min
      http2_enabled                     = site_config.value.http2_enabled
      load_balancing_mode               = site_config.value.load_balancing_mode
      managed_pipeline_mode             = site_config.value.managed_pipeline_mode
      minimum_tls_version               = coalesce(site_config.value.minimum_tls_version, site_config.value.min_tls_version, "1.2")
      remote_debugging_enabled          = site_config.value.remote_debugging_enabled
      remote_debugging_version          = site_config.value.remote_debugging_version
      runtime_scale_monitoring_enabled  = site_config.value.runtime_scale_monitoring_enabled
      use_32_bit_worker                 = site_config.value.use_32_bit_worker
      websockets_enabled                = site_config.value.websockets_enabled

      application_insights_connection_string = site_config.value.application_insights_connection_string
      application_insights_key               = site_config.value.application_insights_key

      pre_warmed_instance_count = site_config.value.pre_warmed_instance_count
      elastic_instance_minimum  = site_config.value.elastic_instance_minimum
      worker_count              = site_config.value.worker_count

      vnet_route_all_enabled = coalesce(site_config.value.vnet_route_all_enabled, var.vnet_integration_subnet_id != null)

      ip_restriction_default_action     = site_config.value.ip_restriction_default_action
      scm_ip_restriction_default_action = site_config.value.scm_ip_restriction_default_action

      dynamic "ip_restriction" {
        for_each = concat(local.subnets, local.cidrs, local.service_tags)
        content {
          name                      = ip_restriction.value.name
          ip_address                = ip_restriction.value.ip_address
          virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
          service_tag               = ip_restriction.value.service_tag
          priority                  = ip_restriction.value.priority
          action                    = ip_restriction.value.action
          headers                   = ip_restriction.value.headers
        }
      }

      dynamic "scm_ip_restriction" {
        for_each = concat(local.scm_subnets, local.scm_cidrs, local.scm_service_tags)
        content {
          name                      = scm_ip_restriction.value.name
          ip_address                = scm_ip_restriction.value.ip_address
          virtual_network_subnet_id = scm_ip_restriction.value.virtual_network_subnet_id
          service_tag               = scm_ip_restriction.value.service_tag
          priority                  = scm_ip_restriction.value.priority
          action                    = scm_ip_restriction.value.action
          headers                   = scm_ip_restriction.value.headers
        }
      }

      scm_type                    = site_config.value.scm_type
      scm_use_main_ip_restriction = length(var.scm_allowed_ips) > 0 || var.scm_allowed_subnet_ids != null ? false : true

      dynamic "application_stack" {
        for_each = site_config.value.application_stack == null ? [] : ["application_stack"]
        content {
          dynamic "docker" {
            for_each = local.site_config.application_stack.docker == null ? [] : ["docker"]
            content {
              registry_url      = local.site_config.application_stack.docker.registry_url
              image_name        = local.site_config.application_stack.docker.image_name
              image_tag         = local.site_config.application_stack.docker.image_tag
              registry_username = local.site_config.application_stack.docker.registry_username
              registry_password = local.site_config.application_stack.docker.registry_password
            }
          }

          dotnet_version              = local.site_config.application_stack.dotnet_version
          use_dotnet_isolated_runtime = local.site_config.application_stack.use_dotnet_isolated_runtime

          java_version            = local.site_config.application_stack.java_version
          node_version            = local.site_config.application_stack.node_version
          python_version          = local.site_config.application_stack.python_version
          powershell_core_version = local.site_config.application_stack.powershell_core_version

          use_custom_runtime = local.site_config.application_stack.use_custom_runtime
        }
      }

      dynamic "cors" {
        for_each = site_config.value.cors != null ? ["cors"] : []
        content {
          allowed_origins     = site_config.value.cors.allowed_origins
          support_credentials = site_config.value.cors.support_credentials
        }
      }

      dynamic "app_service_logs" {
        for_each = site_config.value.app_service_logs != null ? ["app_service_logs"] : []
        content {
          disk_quota_mb         = site_config.value.app_service_logs.disk_quota_mb
          retention_period_days = site_config.value.app_service_logs.retention_period_days
        }
      }
    }
  }

  https_only              = var.https_only
  builtin_logging_enabled = var.builtin_logging_enabled

  dynamic "storage_account" {
    for_each = length(var.staging_slot_mount_points) > 0 ? var.staging_slot_mount_points : var.mount_points
    iterator = mp
    content {
      name         = coalesce(mp.value.name, format("%s-%s", mp.value.account_name, mp.value.share_name))
      type         = mp.value.type
      account_name = mp.value.account_name
      share_name   = mp.value.share_name
      access_key   = mp.value.access_key
      mount_path   = mp.value.mount_path
    }
  }

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

resource "azurerm_windows_function_app_slot" "staging" {
  count = lower(var.os_type) == "windows" && var.staging_slot_enabled ? 1 : 0

  name            = local.staging_slot_name
  function_app_id = azurerm_windows_function_app.main[0].id

  storage_account_name          = local.storage_account.name
  storage_account_access_key    = !var.storage_uses_managed_identity ? local.storage_account.primary_access_key : null
  storage_uses_managed_identity = var.storage_uses_managed_identity ? true : null

  functions_extension_version = "~${var.function_app_version}"

  virtual_network_subnet_id     = var.vnet_integration_subnet_id
  public_network_access_enabled = var.public_network_access_enabled

  app_settings = var.staging_slot_custom_application_settings == null ? {
    for k, v in merge(local.default_application_settings, var.application_settings) : k => v if k != "WEBSITE_RUN_FROM_PACKAGE"
    } : {
    for k, v in merge(local.default_application_settings, var.staging_slot_custom_application_settings) : k => v if k != "WEBSITE_RUN_FROM_PACKAGE"
  }

  # Same site_config as main app (Windows-specific - no Docker support)
  dynamic "site_config" {
    for_each = [local.site_config]
    content {
      always_on                         = site_config.value.always_on
      api_definition_url                = site_config.value.api_definition_url
      api_management_api_id             = site_config.value.api_management_api_id
      app_command_line                  = site_config.value.app_command_line
      app_scale_limit                   = site_config.value.app_scale_limit
      default_documents                 = site_config.value.default_documents
      ftps_state                        = site_config.value.ftps_state
      health_check_path                 = site_config.value.health_check_path
      health_check_eviction_time_in_min = site_config.value.health_check_eviction_time_in_min
      http2_enabled                     = site_config.value.http2_enabled
      load_balancing_mode               = site_config.value.load_balancing_mode
      managed_pipeline_mode             = site_config.value.managed_pipeline_mode
      minimum_tls_version               = coalesce(site_config.value.minimum_tls_version, site_config.value.min_tls_version, "1.2")
      remote_debugging_enabled          = site_config.value.remote_debugging_enabled
      remote_debugging_version          = site_config.value.remote_debugging_version
      runtime_scale_monitoring_enabled  = site_config.value.runtime_scale_monitoring_enabled
      use_32_bit_worker                 = site_config.value.use_32_bit_worker
      websockets_enabled                = site_config.value.websockets_enabled

      application_insights_connection_string = site_config.value.application_insights_connection_string
      application_insights_key               = site_config.value.application_insights_key

      pre_warmed_instance_count = site_config.value.pre_warmed_instance_count
      elastic_instance_minimum  = site_config.value.elastic_instance_minimum
      worker_count              = site_config.value.worker_count

      vnet_route_all_enabled = coalesce(site_config.value.vnet_route_all_enabled, var.vnet_integration_subnet_id != null)

      ip_restriction_default_action     = site_config.value.ip_restriction_default_action
      scm_ip_restriction_default_action = site_config.value.scm_ip_restriction_default_action

      dynamic "ip_restriction" {
        for_each = concat(local.subnets, local.cidrs, local.service_tags)
        content {
          name                      = ip_restriction.value.name
          ip_address                = ip_restriction.value.ip_address
          virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
          service_tag               = ip_restriction.value.service_tag
          priority                  = ip_restriction.value.priority
          action                    = ip_restriction.value.action
          headers                   = ip_restriction.value.headers
        }
      }

      dynamic "scm_ip_restriction" {
        for_each = concat(local.scm_subnets, local.scm_cidrs, local.scm_service_tags)
        content {
          name                      = scm_ip_restriction.value.name
          ip_address                = scm_ip_restriction.value.ip_address
          virtual_network_subnet_id = scm_ip_restriction.value.virtual_network_subnet_id
          service_tag               = scm_ip_restriction.value.service_tag
          priority                  = scm_ip_restriction.value.priority
          action                    = scm_ip_restriction.value.action
          headers                   = scm_ip_restriction.value.headers
        }
      }

      scm_type                    = site_config.value.scm_type
      scm_use_main_ip_restriction = length(var.scm_allowed_ips) > 0 || var.scm_allowed_subnet_ids != null ? false : true

      dynamic "application_stack" {
        for_each = site_config.value.application_stack == null ? [] : ["application_stack"]
        content {
          dotnet_version              = local.site_config.application_stack.dotnet_version
          use_dotnet_isolated_runtime = local.site_config.application_stack.use_dotnet_isolated_runtime

          java_version            = local.site_config.application_stack.java_version
          node_version            = local.site_config.application_stack.node_version
          powershell_core_version = local.site_config.application_stack.powershell_core_version

          use_custom_runtime = local.site_config.application_stack.use_custom_runtime
        }
      }

      dynamic "cors" {
        for_each = site_config.value.cors != null ? ["cors"] : []
        content {
          allowed_origins     = site_config.value.cors.allowed_origins
          support_credentials = site_config.value.cors.support_credentials
        }
      }

      dynamic "app_service_logs" {
        for_each = site_config.value.app_service_logs != null ? ["app_service_logs"] : []
        content {
          disk_quota_mb         = site_config.value.app_service_logs.disk_quota_mb
          retention_period_days = site_config.value.app_service_logs.retention_period_days
        }
      }
    }
  }

  https_only              = var.https_only
  builtin_logging_enabled = var.builtin_logging_enabled

  dynamic "storage_account" {
    for_each = length(var.staging_slot_mount_points) > 0 ? var.staging_slot_mount_points : var.mount_points
    iterator = mp
    content {
      name         = coalesce(mp.value.name, format("%s-%s", mp.value.account_name, mp.value.share_name))
      type         = mp.value.type
      account_name = mp.value.account_name
      share_name   = mp.value.share_name
      access_key   = mp.value.access_key
      mount_path   = mp.value.mount_path
    }
  }

  lifecycle {
    ignore_changes = [
      app_settings.WEBSITE_RUN_FROM_ZIP,
      app_settings.WEBSITE_RUN_FROM_PACKAGE,
      app_settings.MACHINEKEY_DecryptionKey,
      app_settings.WEBSITE_CONTENTAZUREFILECONNECTIONSTRING,
      app_settings.WEBSITE_CONTENTSHARE,
      tags["hidden-link: /app-insights-instrumentation-key"],
      tags["hidden-link: /app-insights-resource-id"],
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
