# App Service Plan
module "app_service_plan" {
  source  = "claranet/app-service-plan/azurerm"
  version = "4.0.0"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short
  name_prefix         = var.app_service_plan_name_prefix != "" ? var.app_service_plan_name_prefix : var.name_prefix
  custom_name         = var.app_service_plan_custom_name

  sku = var.app_service_plan_sku

  kind     = var.app_service_plan_sku["tier"] == "Dynamic" ? "FunctionApp" : var.app_service_plan_os
  reserved = var.app_service_plan_os == "Linux" ? true : var.app_service_plan_reserved

  extra_tags = merge(
    var.extra_tags,
    var.app_service_plan_extra_tags,
    local.default_tags,
  )
}

module "function_app" {
  //  source  = "claranet/function-app-single/azurerm"
  //  version = "4.0.2"
  source = "git::ssh://git@git.fr.clara.net/claranet/projects/cloud/azure/terraform/modules/function-app-single.git?ref=AZ-420-fix-linux-fx-version"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short

  name_prefix                      = var.name_prefix
  storage_account_name_prefix      = var.storage_account_name_prefix
  storage_account_name             = var.storage_account_name
  application_insights_name_prefix = var.application_insights_name_prefix
  function_app_name_prefix         = var.function_app_name_prefix
  function_app_custom_name         = var.function_app_custom_name

  app_service_plan_id               = module.app_service_plan.app_service_plan_id
  function_language_for_linux       = var.function_language_for_linux
  function_app_application_settings = var.function_app_application_settings
  function_app_version              = var.function_app_version

  application_insights_instrumentation_key = var.application_insights_instrumentation_key
  application_insights_type                = var.application_insights_type
  application_insights_custom_name         = var.application_insights_custom_name

  identity_type = var.identity_type
  identity_ids  = var.identity_ids

  os_type = var.function_app_os_type

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

