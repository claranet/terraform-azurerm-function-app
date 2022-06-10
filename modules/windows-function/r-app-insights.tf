data "azurerm_application_insights" "app_insights" {
  count = var.application_insights_enabled && var.application_insights_id != null ? 1 : 0

  name                = split("/", var.application_insights_id)[8]
  resource_group_name = split("/", var.application_insights_id)[4]
}

resource "azurerm_application_insights" "app_insights" {
  count = var.application_insights_enabled && var.application_insights_id == null ? 1 : 0

  name = local.app_insights_name

  location            = var.location
  resource_group_name = var.resource_group_name

  workspace_id     = var.application_insights_log_analytics_workspace_id
  application_type = var.application_insights_type

  daily_data_cap_in_gb                  = var.application_insights_daily_data_cap
  daily_data_cap_notifications_disabled = var.application_insights_daily_data_cap_notifications_disabled
  sampling_percentage                   = var.application_insights_sampling_percentage

  retention_in_days = var.application_insights_retention

  internet_ingestion_enabled = var.application_insights_internet_ingestion_enabled
  internet_query_enabled     = var.application_insights_internet_query_enabled
  disable_ip_masking         = var.application_insights_ip_masking_disabled

  local_authentication_disabled       = var.application_insights_local_authentication_disabled
  force_customer_storage_for_profiler = var.application_insights_force_customer_storage_for_profiler

  tags = merge(
    local.default_tags,
    var.application_insights_extra_tags,
    var.extra_tags,
  )
}
