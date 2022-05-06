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

  application_type = var.application_insights_type

  workspace_id        = var.application_insights_log_analytics_workspace_id
  sampling_percentage = var.application_insights_sampling_percentage

  tags = merge(
    local.default_tags,
    var.application_insights_extra_tags,
    var.extra_tags,
  )
}
