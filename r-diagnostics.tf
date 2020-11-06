module "diagnostics" {
  count  = var.logs_destinations_ids != [] ? 1 : 0
  source = "git::ssh://git@git.fr.clara.net/claranet/projects/cloud/azure/terraform/modules/diagnostic-settings.git?ref=AZ-363-log-analytics-destination-type"

  resource_id           = azurerm_app_service_plan.plan.id
  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = []
  metric_categories     = var.logs_metrics_categories
  retention_days        = var.log_retention_days

}