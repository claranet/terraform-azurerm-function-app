data "azurerm_storage_account" "main" {
  name                = var.use_existing_storage_account ? split("/", var.storage_account_id)[8] : one(module.storage[*].name)
  resource_group_name = var.use_existing_storage_account ? split("/", var.storage_account_id)[4] : var.resource_group_name

  depends_on = [module.storage]
}

data "azurerm_application_insights" "main" {
  count = var.application_insights_enabled && var.application_insights_id != null ? 1 : 0

  name                = element(split("/", var.application_insights_id), 8)
  resource_group_name = element(split("/", var.application_insights_id), 4)
}

data "external" "function_app_settings" {
  count = var.application_settings_drift_ignore ? 1 : 0

  program = ["bash", "${path.module}/../files/webapp_setting.sh"]

  query = {
    resource_group_name = var.resource_group_name
    function_app_name   = local.function_app_name
  }
}
