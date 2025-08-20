module "diagnostics" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "~> 8.0"

  resource_id           = azurerm_function_app_flex_consumption.main.id
  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories
}
