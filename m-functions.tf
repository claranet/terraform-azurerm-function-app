moved {
  from = module.linux_function["enabled"]
  to   = module.linux_function[0]
}

module "linux_function" {
  count = lower(var.os_type) == "linux" ? 1 : 0

  source = "./modules/linux-function"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short

  name_prefix = var.name_prefix
  name_suffix = var.name_suffix

  diagnostic_settings_custom_name = var.diagnostic_settings_custom_name

  storage_uses_managed_identity = var.storage_uses_managed_identity

  storage_account_name_prefix                        = var.storage_account_name_prefix
  storage_account_custom_name                        = var.storage_account_custom_name
  use_existing_storage_account                       = var.use_existing_storage_account
  storage_account_id                                 = var.storage_account_id
  storage_account_advanced_threat_protection_enabled = var.storage_account_advanced_threat_protection_enabled
  storage_account_https_traffic_only_enabled         = var.storage_account_https_traffic_only_enabled
  storage_account_kind                               = var.storage_account_kind
  storage_account_min_tls_version                    = var.storage_account_min_tls_version
  storage_account_identity_type                      = var.storage_account_identity_type
  storage_account_identity_ids                       = var.storage_account_identity_ids

  rbac_storage_contributor_role_principal_ids       = var.rbac_storage_contributor_role_principal_ids
  rbac_storage_blob_role_principal_ids              = var.rbac_storage_blob_role_principal_ids
  rbac_storage_file_role_principal_ids              = var.rbac_storage_file_role_principal_ids
  rbac_storage_table_role_principal_ids             = var.rbac_storage_table_role_principal_ids
  rbac_storage_queue_contributor_role_principal_ids = var.rbac_storage_queue_contributor_role_principal_ids

  service_plan_id = module.service_plan.id

  function_app_name_prefix          = var.function_app_name_prefix
  custom_name                       = var.function_app_custom_name
  application_settings              = var.application_settings
  application_settings_drift_ignore = var.application_settings_drift_ignore
  function_app_version              = var.function_app_version
  site_config                       = var.site_config
  auth_settings_v2                  = var.auth_settings_v2
  sticky_settings                   = var.sticky_settings

  application_insights_name_prefix                           = var.application_insights_name_prefix
  application_insights_enabled                               = var.application_insights_enabled
  application_insights_id                                    = var.application_insights_id
  application_insights_type                                  = var.application_insights_type
  application_insights_custom_name                           = var.application_insights_custom_name
  application_insights_daily_data_cap                        = var.application_insights_daily_data_cap
  application_insights_daily_data_cap_notifications_disabled = var.application_insights_daily_data_cap_notifications_disabled
  application_insights_sampling_percentage                   = var.application_insights_sampling_percentage
  application_insights_retention                             = var.application_insights_retention
  application_insights_internet_ingestion_enabled            = var.application_insights_internet_ingestion_enabled
  application_insights_internet_query_enabled                = var.application_insights_internet_query_enabled
  application_insights_ip_masking_disabled                   = var.application_insights_ip_masking_disabled
  application_insights_local_authentication_disabled         = var.application_insights_local_authentication_disabled
  application_insights_force_customer_storage_for_profiler   = var.application_insights_force_customer_storage_for_profiler
  application_insights_log_analytics_workspace_id            = var.application_insights_log_analytics_workspace_id

  identity_type = var.identity_type
  identity_ids  = var.identity_ids

  allowed_ips                = var.allowed_ips
  allowed_service_tags       = var.allowed_service_tags
  allowed_subnet_ids         = var.allowed_subnet_ids
  ip_restriction_headers     = var.ip_restriction_headers
  vnet_integration_subnet_id = var.vnet_integration_subnet_id

  storage_account_network_rules_enabled = var.storage_account_network_rules_enabled
  storage_account_network_bypass        = var.storage_account_network_bypass
  storage_account_allowed_ips           = var.storage_account_allowed_ips

  scm_allowed_ips            = var.scm_allowed_ips
  scm_allowed_subnet_ids     = var.scm_allowed_subnet_ids
  scm_allowed_service_tags   = var.scm_allowed_service_tags
  scm_ip_restriction_headers = var.scm_ip_restriction_headers

  logs_destinations_ids   = var.logs_destinations_ids
  logs_categories         = var.logs_categories
  logs_metrics_categories = var.logs_metrics_categories

  https_only                 = var.https_only
  builtin_logging_enabled    = var.builtin_logging_enabled
  client_certificate_enabled = var.client_certificate_enabled
  client_certificate_mode    = var.client_certificate_mode

  application_zip_package_path = var.application_zip_package_path

  staging_slot_enabled                     = var.staging_slot_enabled
  staging_slot_custom_name                 = var.staging_slot_custom_name
  staging_slot_custom_application_settings = var.staging_slot_custom_application_settings

  default_tags_enabled = var.default_tags_enabled

  extra_tags = merge(var.extra_tags, local.default_tags)
  application_insights_extra_tags = merge(
    var.extra_tags,
    var.application_insights_extra_tags,
    local.default_tags,
  )
  storage_account_extra_tags = merge(
    var.extra_tags,
    var.storage_account_extra_tags,
    local.default_tags,
  )
  function_app_extra_tags = merge(
    var.extra_tags,
    var.function_app_extra_tags,
    local.default_tags,
  )
}

moved {
  from = module.windows_function["enabled"]
  to   = module.windows_function[0]
}

module "windows_function" {
  count = lower(var.os_type) == "windows" ? 1 : 0

  source = "./modules/windows-function"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short

  name_prefix = var.name_prefix
  name_suffix = var.name_suffix

  diagnostic_settings_custom_name = var.diagnostic_settings_custom_name

  storage_uses_managed_identity = var.storage_uses_managed_identity

  storage_account_name_prefix                        = var.storage_account_name_prefix
  storage_account_custom_name                        = var.storage_account_custom_name
  use_existing_storage_account                       = var.use_existing_storage_account
  storage_account_id                                 = var.storage_account_id
  storage_account_advanced_threat_protection_enabled = var.storage_account_advanced_threat_protection_enabled
  storage_account_https_traffic_only_enabled         = var.storage_account_https_traffic_only_enabled
  storage_account_kind                               = var.storage_account_kind
  storage_account_min_tls_version                    = var.storage_account_min_tls_version
  storage_account_identity_type                      = var.storage_account_identity_type
  storage_account_identity_ids                       = var.storage_account_identity_ids

  service_plan_id = module.service_plan.id

  function_app_name_prefix          = var.function_app_name_prefix
  custom_name                       = var.function_app_custom_name
  application_settings              = var.application_settings
  application_settings_drift_ignore = var.application_settings_drift_ignore
  function_app_version              = var.function_app_version
  site_config                       = var.site_config
  auth_settings_v2                  = var.auth_settings_v2
  sticky_settings                   = var.sticky_settings

  application_insights_name_prefix                           = var.application_insights_name_prefix
  application_insights_enabled                               = var.application_insights_enabled
  application_insights_id                                    = var.application_insights_id
  application_insights_type                                  = var.application_insights_type
  application_insights_custom_name                           = var.application_insights_custom_name
  application_insights_daily_data_cap                        = var.application_insights_daily_data_cap
  application_insights_daily_data_cap_notifications_disabled = var.application_insights_daily_data_cap_notifications_disabled
  application_insights_sampling_percentage                   = var.application_insights_sampling_percentage
  application_insights_retention                             = var.application_insights_retention
  application_insights_internet_ingestion_enabled            = var.application_insights_internet_ingestion_enabled
  application_insights_internet_query_enabled                = var.application_insights_internet_query_enabled
  application_insights_ip_masking_disabled                   = var.application_insights_ip_masking_disabled
  application_insights_local_authentication_disabled         = var.application_insights_local_authentication_disabled
  application_insights_force_customer_storage_for_profiler   = var.application_insights_force_customer_storage_for_profiler
  application_insights_log_analytics_workspace_id            = var.application_insights_log_analytics_workspace_id

  identity_type = var.identity_type
  identity_ids  = var.identity_ids

  allowed_ips                           = var.allowed_ips
  allowed_service_tags                  = var.allowed_service_tags
  allowed_subnet_ids                    = var.allowed_subnet_ids
  ip_restriction_headers                = var.ip_restriction_headers
  vnet_integration_subnet_id            = var.vnet_integration_subnet_id
  storage_account_network_rules_enabled = var.storage_account_network_rules_enabled
  storage_account_network_bypass        = var.storage_account_network_bypass
  storage_account_allowed_ips           = var.storage_account_allowed_ips

  scm_allowed_ips            = var.scm_allowed_ips
  scm_allowed_subnet_ids     = var.scm_allowed_subnet_ids
  scm_allowed_service_tags   = var.scm_allowed_service_tags
  scm_ip_restriction_headers = var.scm_ip_restriction_headers

  logs_destinations_ids   = var.logs_destinations_ids
  logs_categories         = var.logs_categories
  logs_metrics_categories = var.logs_metrics_categories

  https_only                 = var.https_only
  builtin_logging_enabled    = var.builtin_logging_enabled
  client_certificate_enabled = var.client_certificate_enabled
  client_certificate_mode    = var.client_certificate_mode

  application_zip_package_path = var.application_zip_package_path

  staging_slot_enabled                     = var.staging_slot_enabled
  staging_slot_custom_name                 = var.staging_slot_custom_name
  staging_slot_custom_application_settings = var.staging_slot_custom_application_settings

  default_tags_enabled = var.default_tags_enabled

  extra_tags = merge(var.extra_tags, local.default_tags)
  application_insights_extra_tags = merge(
    var.extra_tags,
    var.application_insights_extra_tags,
    local.default_tags,
  )
  storage_account_extra_tags = merge(
    var.extra_tags,
    var.storage_account_extra_tags,
    local.default_tags,
  )
  function_app_extra_tags = merge(
    var.extra_tags,
    var.function_app_extra_tags,
    local.default_tags,
  )
}
