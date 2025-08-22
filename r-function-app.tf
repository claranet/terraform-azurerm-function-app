# Function App resources consolidated from submodules

# Linux Function App
resource "azurerm_linux_function_app" "main" {
  count = lower(var.os_type) == "linux" && !local.is_plan_linux_flex ? 1 : 0

  name = local.function_app_name

  service_plan_id     = module.service_plan.id
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
    ]
  }

  dynamic "auth_settings_v2" {
    for_each = try(local.auth_settings_v2.auth_enabled, false) ? [local.auth_settings_v2] : []
    content {
      auth_enabled                            = try(auth_settings_v2.value.auth_enabled, false)
      runtime_version                         = try(auth_settings_v2.value.runtime_version, "~1")
      config_file_path                        = try(auth_settings_v2.value.config_file_path, null)
      require_authentication                  = try(auth_settings_v2.value.require_authentication, null)
      unauthenticated_action                  = try(auth_settings_v2.value.unauthenticated_action, "RedirectToLoginPage")
      default_provider                        = try(auth_settings_v2.value.default_provider, "azureactivedirectory")
      excluded_paths                          = try(auth_settings_v2.value.excluded_paths, null)
      require_https                           = try(auth_settings_v2.value.require_https, true)
      http_route_api_prefix                   = try(auth_settings_v2.value.http_route_api_prefix, "/.auth")
      forward_proxy_convention                = try(auth_settings_v2.value.forward_proxy_convention, "NoProxy")
      forward_proxy_custom_host_header_name   = try(auth_settings_v2.value.forward_proxy_custom_host_header_name, null)
      forward_proxy_custom_scheme_header_name = try(auth_settings_v2.value.forward_proxy_custom_scheme_header_name, null)

      dynamic "apple_v2" {
        for_each = try(local.auth_settings_v2.apple_v2[*], [])
        content {
          client_id                  = try(apple_v2.value.client_id, null)
          client_secret_setting_name = try(apple_v2.value.client_secret_setting_name, null)
        }
      }

      dynamic "active_directory_v2" {
        for_each = try(local.auth_settings_v2.active_directory_v2[*], [])

        content {
          client_id                            = try(active_directory_v2.value.client_id, null)
          tenant_auth_endpoint                 = try(active_directory_v2.value.tenant_auth_endpoint, null)
          client_secret_setting_name           = try(active_directory_v2.value.client_secret_setting_name, null)
          client_secret_certificate_thumbprint = try(active_directory_v2.value.client_secret_certificate_thumbprint, null)
          jwt_allowed_groups                   = try(active_directory_v2.value.jwt_allowed_groups, null)
          jwt_allowed_client_applications      = try(active_directory_v2.value.jwt_allowed_client_applications, null)
          www_authentication_disabled          = try(active_directory_v2.value.www_authentication_disabled, false)
          allowed_groups                       = try(active_directory_v2.value.allowed_groups, null)
          allowed_identities                   = try(active_directory_v2.value.allowed_identities, null)
          allowed_applications                 = try(active_directory_v2.value.allowed_applications, null)
          login_parameters                     = try(active_directory_v2.value.login_parameters, null)
          allowed_audiences                    = try(active_directory_v2.value.allowed_audiences, null)
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = try(local.auth_settings_v2.azure_static_web_app_v2[*], [])
        content {
          client_id = try(azure_static_web_app_v2.value.client_id, null)
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = try(local.auth_settings_v2.custom_oidc_v2[*], [])
        content {
          name                          = try(custom_oidc_v2.value.name, null)
          client_id                     = try(custom_oidc_v2.value.client_id, null)
          openid_configuration_endpoint = try(custom_oidc_v2.value.openid_configuration_endpoint, null)
          name_claim_type               = try(custom_oidc_v2.value.name_claim_type, null)
          scopes                        = try(custom_oidc_v2.value.scopes, null)
          client_credential_method      = try(custom_oidc_v2.value.client_credential_method, null)
          client_secret_setting_name    = try(custom_oidc_v2.value.client_secret_setting_name, null)
          authorisation_endpoint        = try(custom_oidc_v2.value.authorisation_endpoint, null)
          token_endpoint                = try(custom_oidc_v2.value.token_endpoint, null)
          issuer_endpoint               = try(custom_oidc_v2.value.issuer_endpoint, null)
          certification_uri             = try(custom_oidc_v2.value.certification_uri, null)
        }
      }

      dynamic "facebook_v2" {
        for_each = try(local.auth_settings_v2.facebook_v2[*], [])
        content {
          app_id                  = try(facebook_v2.value.app_id, null)
          app_secret_setting_name = try(facebook_v2.value.app_secret_setting_name, null)
          graph_api_version       = try(facebook_v2.value.graph_api_version, null)
          login_scopes            = try(facebook_v2.value.login_scopes, null)
        }
      }

      dynamic "github_v2" {
        for_each = try(local.auth_settings_v2.github_v2[*], [])
        content {
          client_id                  = try(github_v2.value.client_id, null)
          client_secret_setting_name = try(github_v2.value.client_secret_setting_name, null)
          login_scopes               = try(github_v2.value.login_scopes, null)
        }
      }

      dynamic "google_v2" {
        for_each = try(local.auth_settings_v2.google_v2[*], [])
        content {
          client_id                  = try(google_v2.value.client_id, null)
          client_secret_setting_name = try(google_v2.value.client_secret_setting_name, null)
          allowed_audiences          = try(google_v2.value.allowed_audiences, null)
          login_scopes               = try(google_v2.value.login_scopes, null)
        }
      }

      dynamic "microsoft_v2" {
        for_each = try(local.auth_settings_v2.microsoft_v2[*], [])
        content {
          client_id                  = try(microsoft_v2.value.client_id, null)
          client_secret_setting_name = try(microsoft_v2.value.client_secret_setting_name, null)
          allowed_audiences          = try(microsoft_v2.value.allowed_audiences, null)
          login_scopes               = try(microsoft_v2.value.login_scopes, null)
        }
      }

      dynamic "twitter_v2" {
        for_each = try(local.auth_settings_v2.twitter_v2[*], [])
        content {
          consumer_key                 = try(twitter_v2.value.consumer_key, null)
          consumer_secret_setting_name = try(twitter_v2.value.consumer_secret_setting_name, null)
        }
      }

      login {
        logout_endpoint                   = try(local.auth_settings_v2_login.logout_endpoint, null)
        cookie_expiration_convention      = try(local.auth_settings_v2_login.cookie_expiration_convention, "FixedTime")
        cookie_expiration_time            = try(local.auth_settings_v2_login.cookie_expiration_time, "08:00:00")
        preserve_url_fragments_for_logins = try(local.auth_settings_v2_login.preserve_url_fragments_for_logins, false)
        token_refresh_extension_time      = try(local.auth_settings_v2_login.token_refresh_extension_time, 72)
        token_store_enabled               = try(local.auth_settings_v2_login.token_store_enabled, false)
        token_store_path                  = try(local.auth_settings_v2_login.token_store_path, null)
        token_store_sas_setting_name      = try(local.auth_settings_v2_login.token_store_sas_setting_name, null)
        validate_nonce                    = try(local.auth_settings_v2_login.validate_nonce, true)
        nonce_expiration_time             = try(local.auth_settings_v2_login.nonce_expiration_time, "00:05:00")
        allowed_external_redirect_urls    = try(local.auth_settings_v2_login.allowed_external_redirect_urls, null)
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

# Windows Function App
resource "azurerm_windows_function_app" "main" {
  count = lower(var.os_type) == "windows" ? 1 : 0

  name = local.function_app_name

  service_plan_id     = module.service_plan.id
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
    ]
  }

  # Auth settings v2 - same as Linux
  dynamic "auth_settings_v2" {
    for_each = try(local.auth_settings_v2.auth_enabled, false) ? [local.auth_settings_v2] : []
    content {
      auth_enabled                            = try(auth_settings_v2.value.auth_enabled, false)
      runtime_version                         = try(auth_settings_v2.value.runtime_version, "~1")
      config_file_path                        = try(auth_settings_v2.value.config_file_path, null)
      require_authentication                  = try(auth_settings_v2.value.require_authentication, null)
      unauthenticated_action                  = try(auth_settings_v2.value.unauthenticated_action, "RedirectToLoginPage")
      default_provider                        = try(auth_settings_v2.value.default_provider, "azureactivedirectory")
      excluded_paths                          = try(auth_settings_v2.value.excluded_paths, null)
      require_https                           = try(auth_settings_v2.value.require_https, true)
      http_route_api_prefix                   = try(auth_settings_v2.value.http_route_api_prefix, "/.auth")
      forward_proxy_convention                = try(auth_settings_v2.value.forward_proxy_convention, "NoProxy")
      forward_proxy_custom_host_header_name   = try(auth_settings_v2.value.forward_proxy_custom_host_header_name, null)
      forward_proxy_custom_scheme_header_name = try(auth_settings_v2.value.forward_proxy_custom_scheme_header_name, null)

      dynamic "apple_v2" {
        for_each = try(local.auth_settings_v2.apple_v2[*], [])
        content {
          client_id                  = try(apple_v2.value.client_id, null)
          client_secret_setting_name = try(apple_v2.value.client_secret_setting_name, null)
        }
      }

      dynamic "active_directory_v2" {
        for_each = try(local.auth_settings_v2.active_directory_v2[*], [])
        content {
          client_id                            = try(active_directory_v2.value.client_id, null)
          tenant_auth_endpoint                 = try(active_directory_v2.value.tenant_auth_endpoint, null)
          client_secret_setting_name           = try(active_directory_v2.value.client_secret_setting_name, null)
          client_secret_certificate_thumbprint = try(active_directory_v2.value.client_secret_certificate_thumbprint, null)
          jwt_allowed_groups                   = try(active_directory_v2.value.jwt_allowed_groups, null)
          jwt_allowed_client_applications      = try(active_directory_v2.value.jwt_allowed_client_applications, null)
          www_authentication_disabled          = try(active_directory_v2.value.www_authentication_disabled, false)
          allowed_groups                       = try(active_directory_v2.value.allowed_groups, null)
          allowed_identities                   = try(active_directory_v2.value.allowed_identities, null)
          allowed_applications                 = try(active_directory_v2.value.allowed_applications, null)
          login_parameters                     = try(active_directory_v2.value.login_parameters, null)
          allowed_audiences                    = try(active_directory_v2.value.allowed_audiences, null)
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = try(local.auth_settings_v2.azure_static_web_app_v2[*], [])
        content {
          client_id = try(azure_static_web_app_v2.value.client_id, null)
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = try(local.auth_settings_v2.custom_oidc_v2[*], [])
        content {
          name                          = try(custom_oidc_v2.value.name, null)
          client_id                     = try(custom_oidc_v2.value.client_id, null)
          openid_configuration_endpoint = try(custom_oidc_v2.value.openid_configuration_endpoint, null)
          name_claim_type               = try(custom_oidc_v2.value.name_claim_type, null)
          scopes                        = try(custom_oidc_v2.value.scopes, null)
          client_credential_method      = try(custom_oidc_v2.value.client_credential_method, null)
          client_secret_setting_name    = try(custom_oidc_v2.value.client_secret_setting_name, null)
          authorisation_endpoint        = try(custom_oidc_v2.value.authorisation_endpoint, null)
          token_endpoint                = try(custom_oidc_v2.value.token_endpoint, null)
          issuer_endpoint               = try(custom_oidc_v2.value.issuer_endpoint, null)
          certification_uri             = try(custom_oidc_v2.value.certification_uri, null)
        }
      }

      dynamic "facebook_v2" {
        for_each = try(local.auth_settings_v2.facebook_v2[*], [])
        content {
          app_id                  = try(facebook_v2.value.app_id, null)
          app_secret_setting_name = try(facebook_v2.value.app_secret_setting_name, null)
          graph_api_version       = try(facebook_v2.value.graph_api_version, null)
          login_scopes            = try(facebook_v2.value.login_scopes, null)
        }
      }

      dynamic "github_v2" {
        for_each = try(local.auth_settings_v2.github_v2[*], [])
        content {
          client_id                  = try(github_v2.value.client_id, null)
          client_secret_setting_name = try(github_v2.value.client_secret_setting_name, null)
          login_scopes               = try(github_v2.value.login_scopes, null)
        }
      }

      dynamic "google_v2" {
        for_each = try(local.auth_settings_v2.google_v2[*], [])
        content {
          client_id                  = try(google_v2.value.client_id, null)
          client_secret_setting_name = try(google_v2.value.client_secret_setting_name, null)
          allowed_audiences          = try(google_v2.value.allowed_audiences, null)
          login_scopes               = try(google_v2.value.login_scopes, null)
        }
      }

      dynamic "microsoft_v2" {
        for_each = try(local.auth_settings_v2.microsoft_v2[*], [])
        content {
          client_id                  = try(microsoft_v2.value.client_id, null)
          client_secret_setting_name = try(microsoft_v2.value.client_secret_setting_name, null)
          allowed_audiences          = try(microsoft_v2.value.allowed_audiences, null)
          login_scopes               = try(microsoft_v2.value.login_scopes, null)
        }
      }

      dynamic "twitter_v2" {
        for_each = try(local.auth_settings_v2.twitter_v2[*], [])
        content {
          consumer_key                 = try(twitter_v2.value.consumer_key, null)
          consumer_secret_setting_name = try(twitter_v2.value.consumer_secret_setting_name, null)
        }
      }

      login {
        logout_endpoint                   = try(local.auth_settings_v2_login.logout_endpoint, null)
        cookie_expiration_convention      = try(local.auth_settings_v2_login.cookie_expiration_convention, "FixedTime")
        cookie_expiration_time            = try(local.auth_settings_v2_login.cookie_expiration_time, "08:00:00")
        preserve_url_fragments_for_logins = try(local.auth_settings_v2_login.preserve_url_fragments_for_logins, false)
        token_refresh_extension_time      = try(local.auth_settings_v2_login.token_refresh_extension_time, 72)
        token_store_enabled               = try(local.auth_settings_v2_login.token_store_enabled, false)
        token_store_path                  = try(local.auth_settings_v2_login.token_store_path, null)
        token_store_sas_setting_name      = try(local.auth_settings_v2_login.token_store_sas_setting_name, null)
        validate_nonce                    = try(local.auth_settings_v2_login.validate_nonce, true)
        nonce_expiration_time             = try(local.auth_settings_v2_login.nonce_expiration_time, "00:05:00")
        allowed_external_redirect_urls    = try(local.auth_settings_v2_login.allowed_external_redirect_urls, null)
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

# Flex Function App
resource "azurerm_function_app_flex_consumption" "main" {
  count = local.is_plan_linux_flex ? 1 : 0

  name = local.function_app_name

  location            = var.location
  resource_group_name = var.resource_group_name

  # Required attributes for flex consumption
  service_plan_id = module.service_plan.id
  runtime_name    = var.runtime_name
  runtime_version = var.runtime_version

  storage_container_type            = "blobContainer"
  storage_container_endpoint        = "${data.azurerm_storage_account.main.primary_blob_endpoint}${azurerm_storage_container.flex_container[0].name}"
  storage_authentication_type       = var.storage_uses_managed_identity ? (var.storage_user_assigned_identity_id != null ? "UserAssignedIdentity" : "SystemAssignedIdentity") : "StorageAccountConnectionString"
  storage_access_key                = var.storage_uses_managed_identity ? null : local.storage_account_output.primary_access_key
  storage_user_assigned_identity_id = var.storage_uses_managed_identity ? var.storage_user_assigned_identity_id : null

  # Flex-specific configurations
  maximum_instance_count = var.maximum_instance_count
  instance_memory_in_mb  = var.instance_memory_mb

  public_network_access_enabled = var.public_network_access_enabled

  app_settings = merge(
    local.default_application_settings,
    var.application_settings,
  )

  dynamic "site_config" {
    for_each = [local.site_config]
    content {
      api_definition_url                = site_config.value.api_definition_url
      api_management_api_id             = site_config.value.api_management_api_id
      app_command_line                  = site_config.value.app_command_line
      default_documents                 = site_config.value.default_documents
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

  lifecycle {
    ignore_changes = [
      app_settings.WEBSITE_RUN_FROM_ZIP,
      app_settings.WEBSITE_RUN_FROM_PACKAGE,
      app_settings.MACHINEKEY_DecryptionKey,
      app_settings.WEBSITE_CONTENTAZUREFILECONNECTIONSTRING,
      app_settings.WEBSITE_CONTENTSHARE,
    ]
  }

  # Auth settings v2 - same as Linux/Windows
  dynamic "auth_settings_v2" {
    for_each = try(local.auth_settings_v2.auth_enabled, false) ? [local.auth_settings_v2] : []
    content {
      auth_enabled                            = try(auth_settings_v2.value.auth_enabled, false)
      runtime_version                         = try(auth_settings_v2.value.runtime_version, "~1")
      config_file_path                        = try(auth_settings_v2.value.config_file_path, null)
      require_authentication                  = try(auth_settings_v2.value.require_authentication, null)
      unauthenticated_action                  = try(auth_settings_v2.value.unauthenticated_action, "RedirectToLoginPage")
      default_provider                        = try(auth_settings_v2.value.default_provider, "azureactivedirectory")
      excluded_paths                          = try(auth_settings_v2.value.excluded_paths, null)
      require_https                           = try(auth_settings_v2.value.require_https, true)
      http_route_api_prefix                   = try(auth_settings_v2.value.http_route_api_prefix, "/.auth")
      forward_proxy_convention                = try(auth_settings_v2.value.forward_proxy_convention, "NoProxy")
      forward_proxy_custom_host_header_name   = try(auth_settings_v2.value.forward_proxy_custom_host_header_name, null)
      forward_proxy_custom_scheme_header_name = try(auth_settings_v2.value.forward_proxy_custom_scheme_header_name, null)

      dynamic "apple_v2" {
        for_each = try(local.auth_settings_v2.apple_v2[*], [])
        content {
          client_id                  = try(apple_v2.value.client_id, null)
          client_secret_setting_name = try(apple_v2.value.client_secret_setting_name, null)
        }
      }

      dynamic "active_directory_v2" {
        for_each = try(local.auth_settings_v2.active_directory_v2[*], [])
        content {
          client_id                            = try(active_directory_v2.value.client_id, null)
          tenant_auth_endpoint                 = try(active_directory_v2.value.tenant_auth_endpoint, null)
          client_secret_setting_name           = try(active_directory_v2.value.client_secret_setting_name, null)
          client_secret_certificate_thumbprint = try(active_directory_v2.value.client_secret_certificate_thumbprint, null)
          jwt_allowed_groups                   = try(active_directory_v2.value.jwt_allowed_groups, null)
          jwt_allowed_client_applications      = try(active_directory_v2.value.jwt_allowed_client_applications, null)
          www_authentication_disabled          = try(active_directory_v2.value.www_authentication_disabled, false)
          allowed_groups                       = try(active_directory_v2.value.allowed_groups, null)
          allowed_identities                   = try(active_directory_v2.value.allowed_identities, null)
          allowed_applications                 = try(active_directory_v2.value.allowed_applications, null)
          login_parameters                     = try(active_directory_v2.value.login_parameters, null)
          allowed_audiences                    = try(active_directory_v2.value.allowed_audiences, null)
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = try(local.auth_settings_v2.azure_static_web_app_v2[*], [])
        content {
          client_id = try(azure_static_web_app_v2.value.client_id, null)
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = try(local.auth_settings_v2.custom_oidc_v2[*], [])
        content {
          name                          = try(custom_oidc_v2.value.name, null)
          client_id                     = try(custom_oidc_v2.value.client_id, null)
          openid_configuration_endpoint = try(custom_oidc_v2.value.openid_configuration_endpoint, null)
          name_claim_type               = try(custom_oidc_v2.value.name_claim_type, null)
          scopes                        = try(custom_oidc_v2.value.scopes, null)
          client_credential_method      = try(custom_oidc_v2.value.client_credential_method, null)
          client_secret_setting_name    = try(custom_oidc_v2.value.client_secret_setting_name, null)
          authorisation_endpoint        = try(custom_oidc_v2.value.authorisation_endpoint, null)
          token_endpoint                = try(custom_oidc_v2.value.token_endpoint, null)
          issuer_endpoint               = try(custom_oidc_v2.value.issuer_endpoint, null)
          certification_uri             = try(custom_oidc_v2.value.certification_uri, null)
        }
      }

      dynamic "facebook_v2" {
        for_each = try(local.auth_settings_v2.facebook_v2[*], [])
        content {
          app_id                  = try(facebook_v2.value.app_id, null)
          app_secret_setting_name = try(facebook_v2.value.app_secret_setting_name, null)
          graph_api_version       = try(facebook_v2.value.graph_api_version, null)
          login_scopes            = try(facebook_v2.value.login_scopes, null)
        }
      }

      dynamic "github_v2" {
        for_each = try(local.auth_settings_v2.github_v2[*], [])
        content {
          client_id                  = try(github_v2.value.client_id, null)
          client_secret_setting_name = try(github_v2.value.client_secret_setting_name, null)
          login_scopes               = try(github_v2.value.login_scopes, null)
        }
      }

      dynamic "google_v2" {
        for_each = try(local.auth_settings_v2.google_v2[*], [])
        content {
          client_id                  = try(google_v2.value.client_id, null)
          client_secret_setting_name = try(google_v2.value.client_secret_setting_name, null)
          allowed_audiences          = try(google_v2.value.allowed_audiences, null)
          login_scopes               = try(google_v2.value.login_scopes, null)
        }
      }

      dynamic "microsoft_v2" {
        for_each = try(local.auth_settings_v2.microsoft_v2[*], [])
        content {
          client_id                  = try(microsoft_v2.value.client_id, null)
          client_secret_setting_name = try(microsoft_v2.value.client_secret_setting_name, null)
          allowed_audiences          = try(microsoft_v2.value.allowed_audiences, null)
          login_scopes               = try(microsoft_v2.value.login_scopes, null)
        }
      }

      dynamic "twitter_v2" {
        for_each = try(local.auth_settings_v2.twitter_v2[*], [])
        content {
          consumer_key                 = try(twitter_v2.value.consumer_key, null)
          consumer_secret_setting_name = try(twitter_v2.value.consumer_secret_setting_name, null)
        }
      }

      login {
        logout_endpoint                   = try(local.auth_settings_v2_login.logout_endpoint, null)
        cookie_expiration_convention      = try(local.auth_settings_v2_login.cookie_expiration_convention, "FixedTime")
        cookie_expiration_time            = try(local.auth_settings_v2_login.cookie_expiration_time, "08:00:00")
        preserve_url_fragments_for_logins = try(local.auth_settings_v2_login.preserve_url_fragments_for_logins, false)
        token_refresh_extension_time      = try(local.auth_settings_v2_login.token_refresh_extension_time, 72)
        token_store_enabled               = try(local.auth_settings_v2_login.token_store_enabled, false)
        token_store_path                  = try(local.auth_settings_v2_login.token_store_path, null)
        token_store_sas_setting_name      = try(local.auth_settings_v2_login.token_store_sas_setting_name, null)
        validate_nonce                    = try(local.auth_settings_v2_login.validate_nonce, true)
        nonce_expiration_time             = try(local.auth_settings_v2_login.nonce_expiration_time, "00:05:00")
        allowed_external_redirect_urls    = try(local.auth_settings_v2_login.allowed_external_redirect_urls, null)
      }
    }
  }

  dynamic "always_ready" {
    for_each = var.always_ready_instance_count != null ? [var.always_ready_instance_count] : []
    content {
      name           = format("%s-always-ready", local.function_app_name)
      instance_count = always_ready.value
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
