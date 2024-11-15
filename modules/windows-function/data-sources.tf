data "azurerm_subscription" "current" {}

data "azurerm_service_plan" "main" {
  name                = element(split("/", var.service_plan_id), 8)
  resource_group_name = element(split("/", var.service_plan_id), 4)
}

data "azurerm_storage_account" "main" {
  name                = var.use_existing_storage_account ? split("/", var.storage_account_id)[8] : one(module.storage[*].name)
  resource_group_name = var.use_existing_storage_account ? split("/", var.storage_account_id)[4] : var.resource_group_name

  depends_on = [module.storage]
}
