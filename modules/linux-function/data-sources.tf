data "azurerm_subscription" "current" {}

data "azurerm_service_plan" "main" {
  name                = provider::azurerm::parse_resource_id(var.service_plan_id).resource_name
  resource_group_name = provider::azurerm::parse_resource_id(var.service_plan_id).resource_group_name
}

data "azurerm_storage_account" "main" {
  count = var.use_existing_storage_account ? 1 : 0

  name                = provider::azurerm::parse_resource_id(var.storage_account_id).resource_name
  resource_group_name = provider::azurerm::parse_resource_id(var.storage_account_id).resource_group_name
}
