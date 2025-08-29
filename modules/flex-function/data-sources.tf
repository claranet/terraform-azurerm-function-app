data "azurerm_subscription" "current" {}

data "azurerm_storage_account" "main" {
  count = var.use_existing_storage_account ? 1 : 0

  name                = provider::azurerm::parse_resource_id(var.storage_account_id).resource_name
  resource_group_name = provider::azurerm::parse_resource_id(var.storage_account_id).resource_group_name
}

data "azurerm_application_insights" "main" {
  count = var.application_insights_enabled && var.application_insights_id != null ? 1 : 0

  name                = provider::azurerm::parse_resource_id(var.application_insights_id).resource_name
  resource_group_name = provider::azurerm::parse_resource_id(var.application_insights_id).resource_group_name
}

data "external" "function_app_settings" {
  count = var.application_settings_drift_ignore ? 1 : 0

  program = ["bash", "${path.module}/../../files/webapp_setting.sh"]

  query = {
    webapp_name  = local.function_app_name
    rg_name      = var.resource_group_name
    subscription = data.azurerm_subscription.current.subscription_id
  }
}
