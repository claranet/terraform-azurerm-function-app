# App Service Plan
module "app_service_plan" {
  source  = "claranet/app-service-plan/azurerm"
  version = "5.0.0"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short

  use_caf_naming = var.use_caf_naming
  name_prefix    = var.app_service_plan_name_prefix != "" ? var.app_service_plan_name_prefix : var.name_prefix
  name_suffix    = var.name_suffix
  custom_name    = var.app_service_plan_custom_name

  sku = var.app_service_plan_sku

  kind     = var.app_service_plan_sku["tier"] == "Dynamic" ? "FunctionApp" : var.app_service_plan_os
  reserved = var.app_service_plan_os == "Linux" ? true : var.app_service_plan_reserved

  logs_destinations_ids   = var.logs_destinations_ids
  logs_retention_days     = var.logs_retention_days
  logs_categories         = var.logs_categories
  logs_metrics_categories = var.logs_metrics_categories

  extra_tags = merge(
    var.extra_tags,
    var.app_service_plan_extra_tags,
    local.default_tags,
  )
}

module "function_app" {
  source = "./modules/functionapp"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short

  name_prefix = var.name_prefix

  storage_account_name_prefix                       = var.storage_account_name_prefix
  storage_account_name                              = var.storage_account_name
  storage_account_access_key                        = var.storage_account_access_key
  storage_account_enable_advanced_threat_protection = var.storage_account_enable_advanced_threat_protection
  storage_account_enable_https_traffic_only         = var.storage_account_enable_https_traffic_only
  storage_account_kind                              = var.storage_account_kind
  storage_account_min_tls_version                   = var.storage_account_min_tls_version

  app_service_plan_id = module.app_service_plan.app_service_plan_id

  function_app_name_prefix          = var.function_app_name_prefix
  function_app_custom_name          = var.function_app_custom_name
  function_language_for_linux       = var.function_language_for_linux
  function_app_application_settings = var.function_app_application_settings
  function_app_version              = var.function_app_version

  application_insights_name_prefix = var.application_insights_name_prefix
  application_insights_enabled     = var.application_insights_enabled
  application_insights_id          = var.application_insights_id
  application_insights_type        = var.application_insights_type
  application_insights_custom_name = var.application_insights_custom_name
  site_config                      = var.function_app_site_config

  identity_type = var.identity_type
  identity_ids  = var.identity_ids

  authorized_ips                          = var.authorized_ips
  authorized_service_tags                 = var.authorized_service_tags
  authorized_subnet_ids                   = var.authorized_subnet_ids
  ip_restriction_headers                  = var.ip_restriction_headers
  function_app_vnet_integration_enabled   = var.function_app_vnet_integration_enabled
  function_app_vnet_integration_subnet_id = var.function_app_vnet_integration_subnet_id

  scm_authorized_ips          = var.scm_authorized_ips
  scm_authorized_subnet_ids   = var.scm_authorized_subnet_ids
  scm_authorized_service_tags = var.scm_authorized_service_tags
  scm_ip_restriction_headers  = var.scm_ip_restriction_headers

  logs_destinations_ids   = var.logs_destinations_ids
  logs_retention_days     = var.logs_retention_days
  logs_categories         = var.logs_categories
  logs_metrics_categories = var.logs_metrics_categories

  os_type    = lower(var.app_service_plan_os) == "linux" ? "linux" : ""
  https_only = var.https_only

  application_zip_package_path = var.application_zip_package_path

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
