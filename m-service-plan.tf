module "service_plan" {
  source  = "claranet/app-service-plan/azurerm"
  version = "~> 8.2.0"

  location       = var.location
  location_short = var.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name

  name_prefix = var.name_prefix
  name_suffix = var.name_suffix

  custom_name                     = var.service_plan_custom_name
  diagnostic_settings_custom_name = var.diagnostic_settings_custom_name

  os_type  = var.os_type
  sku_name = var.sku_name

  app_service_environment_id = var.app_service_environment_id

  worker_count                 = var.worker_count
  maximum_elastic_worker_count = var.maximum_elastic_worker_count
  per_site_scaling_enabled     = var.per_site_scaling_enabled

  zone_balancing_enabled = var.zone_balancing_enabled

  logs_destinations_ids   = var.logs_destinations_ids
  logs_categories         = var.logs_categories
  logs_metrics_categories = var.logs_metrics_categories

  default_tags_enabled = var.default_tags_enabled

  extra_tags = merge(local.default_tags, var.extra_tags, var.service_plan_extra_tags)
}

moved {
  from = module.app_service_plan
  to   = module.service_plan
}
