module "diagnostics" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "4.0.3"

  resource_id           = azurerm_function_app.function_app.id
  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories
  retention_days        = var.logs_retention_days
}
