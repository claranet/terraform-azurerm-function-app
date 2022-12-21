module "linux_function" {
  for_each = toset(lower(var.os_type) == "linux" ? ["enabled"] : [])

  source = "./modules/linux-function"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short

  use_caf_naming = var.use_caf_naming
  name_prefix    = var.name_prefix
  name_suffix    = var.name_suffix

  custom_diagnostic_settings_name = var.custom_diagnostic_settings_name

  storage_account_name_prefix                       = var.storage_account_name_prefix
  storage_account_name                              = var.storage_account_name
  storage_account_access_key                        = var.storage_account_access_key
  storage_account_enable_advanced_threat_protection = var.storage_account_enable_advanced_threat_protection
  storage_account_enable_https_traffic_only         = var.storage_account_enable_https_traffic_only
  storage_account_kind                              = var.storage_account_kind
  storage_account_min_tls_version                   = var.storage_account_min_tls_version
  storage_account_identity_type                     = var.storage_account_identity_type
  storage_account_identity_ids                      = var.storage_account_identity_ids

  service_plan_id = module.service_plan.service_plan_id

  function_app_name_prefix          = var.function_app_name_prefix
  function_app_custom_name          = var.function_app_custom_name
  function_app_application_settings = var.function_app_application_settings
  function_app_version              = var.function_app_version
  site_config                       = var.function_app_site_config

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

  authorized_ips                          = var.authorized_ips
  authorized_service_tags                 = var.authorized_service_tags
  authorized_subnet_ids                   = var.authorized_subnet_ids
  ip_restriction_headers                  = var.ip_restriction_headers
  function_app_vnet_integration_subnet_id = var.function_app_vnet_integration_subnet_id
  storage_account_network_rules_enabled   = var.storage_account_network_rules_enabled
  storage_account_network_bypass          = var.storage_account_network_bypass
  storage_account_authorized_ips          = var.storage_account_authorized_ips

  scm_authorized_ips          = var.scm_authorized_ips
  scm_authorized_subnet_ids   = var.scm_authorized_subnet_ids
  scm_authorized_service_tags = var.scm_authorized_service_tags
  scm_ip_restriction_headers  = var.scm_ip_restriction_headers

  logs_destinations_ids   = var.logs_destinations_ids
  logs_retention_days     = var.logs_retention_days
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
  from = module.function_app
  to   = module.linux_function
}

module "windows_function" {
  for_each = toset(lower(var.os_type) == "windows" ? ["enabled"] : [])

  source = "./modules/windows-function"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short

  use_caf_naming = var.use_caf_naming
  name_prefix    = var.name_prefix
  name_suffix    = var.name_suffix

  custom_diagnostic_settings_name = var.custom_diagnostic_settings_name

  storage_account_name_prefix                       = var.storage_account_name_prefix
  storage_account_name                              = var.storage_account_name
  storage_account_access_key                        = var.storage_account_access_key
  storage_account_enable_advanced_threat_protection = var.storage_account_enable_advanced_threat_protection
  storage_account_enable_https_traffic_only         = var.storage_account_enable_https_traffic_only
  storage_account_kind                              = var.storage_account_kind
  storage_account_min_tls_version                   = var.storage_account_min_tls_version
  storage_account_identity_type                     = var.storage_account_identity_type
  storage_account_identity_ids                      = var.storage_account_identity_ids

  service_plan_id = module.service_plan.service_plan_id

  function_app_name_prefix          = var.function_app_name_prefix
  function_app_custom_name          = var.function_app_custom_name
  function_app_application_settings = var.function_app_application_settings
  function_app_version              = var.function_app_version
  site_config                       = var.function_app_site_config

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

  authorized_ips                          = var.authorized_ips
  authorized_service_tags                 = var.authorized_service_tags
  authorized_subnet_ids                   = var.authorized_subnet_ids
  ip_restriction_headers                  = var.ip_restriction_headers
  function_app_vnet_integration_subnet_id = var.function_app_vnet_integration_subnet_id
  storage_account_network_rules_enabled   = var.storage_account_network_rules_enabled
  storage_account_network_bypass          = var.storage_account_network_bypass
  storage_account_authorized_ips          = var.storage_account_authorized_ips

  scm_authorized_ips          = var.scm_authorized_ips
  scm_authorized_subnet_ids   = var.scm_authorized_subnet_ids
  scm_authorized_service_tags = var.scm_authorized_service_tags
  scm_ip_restriction_headers  = var.scm_ip_restriction_headers

  logs_destinations_ids   = var.logs_destinations_ids
  logs_retention_days     = var.logs_retention_days
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
