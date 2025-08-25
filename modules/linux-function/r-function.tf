# Function App

moved {
  from = azurerm_linux_function_app.linux_function
  to   = azurerm_linux_function_app.main
}

resource "azurerm_linux_function_app" "main" {
  name = local.function_app_name

  service_plan_id     = var.service_plan_id
  location            = var.location
  resource_group_name = var.resource_group_name

  storage_account_name          = data.azurerm_storage_account.main.name
  storage_account_access_key    = !var.storage_uses_managed_identity ? data.azurerm_storage_account.main.primary_access_key : null
  storage_uses_managed_identity = var.storage_uses_managed_identity ? true : null

  functions_extension_version = "~${var.function_app_version}"

  virtual_network_subnet_id     = var.vnet_integration_subnet_id
  public_network_access_enabled = var.public_network_access_enabled

  app_settings = merge(
    local.default_application_settings,
    var.application_settings,
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
      use_32_bit_worker                 = lookup(site_config.value, "use_32_bit_worker", null)
      websockets_enabled                = lookup(site_config.value, "websockets_enabled", false)

      application_insights_connection_string = lookup(site_config.value, "application_insights_connection_string", null)
      application_insights_key               = lookup(site_config.value, "application_insights_key", false)

      pre_warmed_instance_count = lookup(site_config.value, "pre_warmed_instance_count", null)
      elastic_instance_minimum  = lookup(site_config.value, "elastic_instance_minimum", null)
      worker_count              = lookup(site_config.value, "worker_count", null)

      vnet_route_all_enabled = lookup(site_config.value, "vnet_route_all_enabled", var.vnet_integration_subnet_id != null)

      ip_restriction_default_action     = lookup(site_config.value, "ip_restriction_default_action", "Deny")
      scm_ip_restriction_default_action = lookup(site_config.value, "scm_ip_restriction_default_action", "Deny")

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

      scm_type                    = lookup(site_config.value, "scm_type", null)
      scm_use_main_ip_restriction = length(var.scm_allowed_ips) > 0 || var.scm_allowed_subnet_ids != null ? false : true

      dynamic "application_stack" {
        for_each = lookup(site_config.value, "application_stack", null) == null ? [] : ["application_stack"]
        content {
          dynamic "docker" {
            for_each = lookup(local.site_config.application_stack, "docker", null) == null ? [] : ["docker"]
            content {
              registry_url      = local.site_config.application_stack.docker.registry_url
              image_name        = local.site_config.application_stack.docker.image_name
              image_tag         = local.site_config.application_stack.docker.image_tag
              registry_username = lookup(local.site_config.application_stack.docker, "registry_username", null)
              registry_password = lookup(local.site_config.application_stack.docker, "registry_password", null)
            }
          }

          dotnet_version              = lookup(local.site_config.application_stack, "dotnet_version", null)
          use_dotnet_isolated_runtime = lookup(local.site_config.application_stack, "use_dotnet_isolated_runtime", null)

          java_version            = lookup(local.site_config.application_stack, "java_version", null)
          node_version            = lookup(local.site_config.application_stack, "node_version", null)
          python_version          = lookup(local.site_config.application_stack, "python_version", null)
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

      dynamic "app_service_logs" {
        for_each = lookup(site_config.value, "app_service_logs", null) != null ? ["app_service_logs"] : []
        content {
          disk_quota_mb         = lookup(site_config.value.app_service_logs, "disk_quota_mb", null)
          retention_period_days = lookup(site_config.value.app_service_logs, "retention_period_days", null)
        }
      }
    }
  }

  dynamic "sticky_settings" {
    for_each = var.sticky_settings[*]
    content {
      app_setting_names       = sticky_settings.value.app_setting_names
      connection_string_names = sticky_settings.value.connection_string_names
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
      tags["hidden-link: /app-insights-instrumentation-key"],
      tags["hidden-link: /app-insights-resource-id"],
    ]
  }

  dynamic "auth_settings_v2" {
    for_each = lookup(local.auth_settings_v2, "auth_enabled", false) ? [local.auth_settings_v2] : []
    content {
      auth_enabled                            = lookup(auth_settings_v2.value, "auth_enabled", false)
      runtime_version                         = lookup(auth_settings_v2.value, "runtime_version", "~1")
      config_file_path                        = lookup(auth_settings_v2.value, "config_file_path", null)
      require_authentication                  = lookup(auth_settings_v2.value, "require_authentication", null)
      unauthenticated_action                  = lookup(auth_settings_v2.value, "unauthenticated_action", "RedirectToLoginPage")
      default_provider                        = lookup(auth_settings_v2.value, "default_provider", "azureactivedirectory")
      excluded_paths                          = lookup(auth_settings_v2.value, "excluded_paths", null)
      require_https                           = lookup(auth_settings_v2.value, "require_https", true)
      http_route_api_prefix                   = lookup(auth_settings_v2.value, "http_route_api_prefix", "/.auth")
      forward_proxy_convention                = lookup(auth_settings_v2.value, "forward_proxy_convention", "NoProxy")
      forward_proxy_custom_host_header_name   = lookup(auth_settings_v2.value, "forward_proxy_custom_host_header_name", null)
      forward_proxy_custom_scheme_header_name = lookup(auth_settings_v2.value, "forward_proxy_custom_scheme_header_name", null)

      dynamic "apple_v2" {
        for_each = try(local.auth_settings_v2.apple_v2[*], [])
        content {
          client_id                  = lookup(apple_v2.value, "client_id", null)
          client_secret_setting_name = lookup(apple_v2.value, "client_secret_setting_name", null)
        }
      }

      dynamic "active_directory_v2" {
        for_each = try(local.auth_settings_v2.active_directory_v2[*], [])

        content {
          client_id                            = lookup(active_directory_v2.value, "client_id", null)
          tenant_auth_endpoint                 = lookup(active_directory_v2.value, "tenant_auth_endpoint", null)
          client_secret_setting_name           = lookup(active_directory_v2.value, "client_secret_setting_name", null)
          client_secret_certificate_thumbprint = lookup(active_directory_v2.value, "client_secret_certificate_thumbprint", null)
          jwt_allowed_groups                   = lookup(active_directory_v2.value, "jwt_allowed_groups", null)
          jwt_allowed_client_applications      = lookup(active_directory_v2.value, "jwt_allowed_client_applications", null)
          www_authentication_disabled          = lookup(active_directory_v2.value, "www_authentication_disabled", false)
          allowed_groups                       = lookup(active_directory_v2.value, "allowed_groups", null)
          allowed_identities                   = lookup(active_directory_v2.value, "allowed_identities", null)
          allowed_applications                 = lookup(active_directory_v2.value, "allowed_applications", null)
          login_parameters                     = lookup(active_directory_v2.value, "login_parameters", null)
          allowed_audiences                    = lookup(active_directory_v2.value, "allowed_audiences", null)
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = try(local.auth_settings_v2.azure_static_web_app_v2[*], [])
        content {
          client_id = lookup(azure_static_web_app_v2.value, "client_id", null)
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = try(local.auth_settings_v2.custom_oidc_v2[*], [])
        content {
          name                          = lookup(custom_oidc_v2.value, "name", null)
          client_id                     = lookup(custom_oidc_v2.value, "client_id", null)
          openid_configuration_endpoint = lookup(custom_oidc_v2.value, "openid_configuration_endpoint", null)
          name_claim_type               = lookup(custom_oidc_v2.value, "name_claim_type", null)
          scopes                        = lookup(custom_oidc_v2.value, "scopes", null)
          client_credential_method      = lookup(custom_oidc_v2.value, "client_credential_method", null)
          client_secret_setting_name    = lookup(custom_oidc_v2.value, "client_secret_setting_name", null)
          authorisation_endpoint        = lookup(custom_oidc_v2.value, "authorisation_endpoint", null)
          token_endpoint                = lookup(custom_oidc_v2.value, "token_endpoint", null)
          issuer_endpoint               = lookup(custom_oidc_v2.value, "issuer_endpoint", null)
          certification_uri             = lookup(custom_oidc_v2.value, "certification_uri", null)
        }
      }

      dynamic "facebook_v2" {
        for_each = try(local.auth_settings_v2.facebook_v2[*], [])
        content {
          app_id                  = lookup(facebook_v2.value, "app_id", null)
          app_secret_setting_name = lookup(facebook_v2.value, "app_secret_setting_name", null)
          graph_api_version       = lookup(facebook_v2.value, "graph_api_version", null)
          login_scopes            = lookup(facebook_v2.value, "login_scopes", null)
        }
      }

      dynamic "github_v2" {
        for_each = try(local.auth_settings_v2.github_v2[*], [])
        content {
          client_id                  = lookup(github_v2.value, "client_id", null)
          client_secret_setting_name = lookup(github_v2.value, "client_secret_setting_name", null)
          login_scopes               = lookup(github_v2.value, "login_scopes", null)
        }
      }

      dynamic "google_v2" {
        for_each = try(local.auth_settings_v2.google_v2[*], [])
        content {
          client_id                  = lookup(google_v2.value, "client_id", null)
          client_secret_setting_name = lookup(google_v2.value, "client_secret_setting_name", null)
          allowed_audiences          = lookup(google_v2.value, "allowed_audiences", null)
          login_scopes               = lookup(google_v2.value, "login_scopes", null)
        }
      }

      dynamic "microsoft_v2" {
        for_each = try(local.auth_settings_v2.microsoft_v2[*], [])
        content {
          client_id                  = lookup(microsoft_v2.value, "client_id", null)
          client_secret_setting_name = lookup(microsoft_v2.value, "client_secret_setting_name", null)
          allowed_audiences          = lookup(microsoft_v2.value, "allowed_audiences", null)
          login_scopes               = lookup(microsoft_v2.value, "login_scopes", null)
        }
      }

      dynamic "twitter_v2" {
        for_each = try(local.auth_settings_v2.twitter_v2[*], [])
        content {
          consumer_key                 = lookup(twitter_v2.value, "consumer_key", null)
          consumer_secret_setting_name = lookup(twitter_v2.value, "consumer_secret_setting_name", null)
        }
      }

      login {
        logout_endpoint                   = lookup(local.auth_settings_v2_login, "logout_endpoint", null)
        cookie_expiration_convention      = lookup(local.auth_settings_v2_login, "cookie_expiration_convention", "FixedTime")
        cookie_expiration_time            = lookup(local.auth_settings_v2_login, "cookie_expiration_time", "08:00:00")
        preserve_url_fragments_for_logins = lookup(local.auth_settings_v2_login, "preserve_url_fragments_for_logins", false)
        token_refresh_extension_time      = lookup(local.auth_settings_v2_login, "token_refresh_extension_time", 72)
        token_store_enabled               = lookup(local.auth_settings_v2_login, "token_store_enabled", false)
        token_store_path                  = lookup(local.auth_settings_v2_login, "token_store_path", null)
        token_store_sas_setting_name      = lookup(local.auth_settings_v2_login, "token_store_sas_setting_name", null)
        validate_nonce                    = lookup(local.auth_settings_v2_login, "validate_nonce", true)
        nonce_expiration_time             = lookup(local.auth_settings_v2_login, "nonce_expiration_time", "00:05:00")
        allowed_external_redirect_urls    = lookup(local.auth_settings_v2_login, "allowed_external_redirect_urls", null)
      }
    }
  }

  dynamic "storage_account" {
    for_each = var.mount_points
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

moved {
  from = azurerm_linux_function_app_slot.linux_function_slot
  to   = azurerm_linux_function_app_slot.staging
}

resource "azurerm_linux_function_app_slot" "staging" {
  count = var.staging_slot_enabled ? 1 : 0

  name            = local.staging_slot_name
  function_app_id = azurerm_linux_function_app.main.id

  storage_account_name          = data.azurerm_storage_account.main.name
  storage_account_access_key    = !var.storage_uses_managed_identity ? data.azurerm_storage_account.main.primary_access_key : null
  storage_uses_managed_identity = var.storage_uses_managed_identity ? true : null

  functions_extension_version = "~${var.function_app_version}"

  public_network_access_enabled = var.public_network_access_enabled
  virtual_network_subnet_id     = var.vnet_integration_subnet_id

  app_settings = var.staging_slot_custom_application_settings == null ? {
    for k, v in merge(local.default_application_settings, var.application_settings) : k => v if k != "WEBSITE_RUN_FROM_PACKAGE"
    } : {
    for k, v in merge(local.default_application_settings, var.staging_slot_custom_application_settings) : k => v if k != "WEBSITE_RUN_FROM_PACKAGE"
  }

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
      use_32_bit_worker                 = lookup(site_config.value, "use_32_bit_worker", null)
      websockets_enabled                = lookup(site_config.value, "websockets_enabled", false)

      application_insights_connection_string = lookup(site_config.value, "application_insights_connection_string", null)
      application_insights_key               = lookup(site_config.value, "application_insights_key", false)

      pre_warmed_instance_count = lookup(site_config.value, "pre_warmed_instance_count", null)
      elastic_instance_minimum  = lookup(site_config.value, "elastic_instance_minimum", null)
      worker_count              = lookup(site_config.value, "worker_count", null)

      vnet_route_all_enabled = lookup(site_config.value, "vnet_route_all_enabled", var.vnet_integration_subnet_id != null)

      ip_restriction_default_action     = lookup(site_config.value, "ip_restriction_default_action", "Deny")
      scm_ip_restriction_default_action = lookup(site_config.value, "scm_ip_restriction_default_action", "Deny")

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

      scm_type                    = lookup(site_config.value, "scm_type", null)
      scm_use_main_ip_restriction = length(var.scm_allowed_ips) > 0 || var.scm_allowed_subnet_ids != null ? false : true

      dynamic "application_stack" {
        for_each = lookup(site_config.value, "application_stack", null) == null ? [] : ["application_stack"]
        content {
          dynamic "docker" {
            for_each = lookup(local.site_config.application_stack, "docker", null) == null ? [] : ["docker"]
            content {
              registry_url      = local.site_config.application_stack.docker.registry_url
              image_name        = local.site_config.application_stack.docker.image_name
              image_tag         = local.site_config.application_stack.docker.image_tag
              registry_username = lookup(local.site_config.application_stack.docker, "registry_username", null)
              registry_password = lookup(local.site_config.application_stack.docker, "registry_password", null)
            }
          }

          dotnet_version              = lookup(local.site_config.application_stack, "dotnet_version", null)
          use_dotnet_isolated_runtime = lookup(local.site_config.application_stack, "use_dotnet_isolated_runtime", null)

          java_version            = lookup(local.site_config.application_stack, "java_version", null)
          node_version            = lookup(local.site_config.application_stack, "node_version", null)
          python_version          = lookup(local.site_config.application_stack, "python_version", null)
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

      dynamic "app_service_logs" {
        for_each = lookup(site_config.value, "app_service_logs", null) != null ? ["app_service_logs"] : []
        content {
          disk_quota_mb         = lookup(site_config.value.app_service_logs, "disk_quota_mb", null)
          retention_period_days = lookup(site_config.value.app_service_logs, "retention_period_days", null)
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
