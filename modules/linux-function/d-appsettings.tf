data "azurerm_subscription" "current" {}

data "external" "app_service_settings" {
  count   = var.function_app_application_settings_drift_ignore ? 1 : 0
  program = ["sh", format("%s/../../files/webapp_setting.sh", path.module)]
  query = {
    webapp_name  = local.function_app_name
    rg_name      = var.resource_group_name
    subscription = data.azurerm_subscription.current.subscription_id
  }
}
