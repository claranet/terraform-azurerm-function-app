resource "azurerm_storage_account_network_rules" "main" {
  count = !var.use_existing_storage_account && var.storage_account_network_rules_enabled ? 1 : 0

  storage_account_id = local.storage_account.id

  default_action             = "Deny"
  ip_rules                   = local.storage_account_allowed_ips
  virtual_network_subnet_ids = distinct(compact(concat(var.allowed_subnet_ids, var.vnet_integration_subnet_id[*])))
  bypass                     = var.storage_account_network_bypass

  lifecycle {
    precondition {
      condition     = !local.is_consumption
      error_message = "When a Function App is running on a Consumption Plan (Y1) in the same region as the Storage Account, network rules cannot be configured on that Storage Account."
    }
  }
}

resource "azurerm_storage_container" "package_container" {
  count = var.application_zip_package_path != null && local.is_local_zip ? 1 : 0

  name                  = "functions-packages"
  storage_account_id    = local.storage_account.id
  container_access_type = "private"
}

resource "azurerm_storage_blob" "package_blob" {
  count = var.application_zip_package_path != null && local.is_local_zip ? 1 : 0

  name                   = "${local.function_app_name}.zip"
  storage_account_name   = local.storage_account.name
  storage_container_name = azurerm_storage_container.package_container[0].name
  type                   = "Block"
  source                 = var.application_zip_package_path
  content_md5            = filemd5(var.application_zip_package_path)
}

resource "azurerm_storage_container" "flex_container" {
  count = local.is_linux_flex ? 1 : 0

  name                  = "functions-flex"
  storage_account_id    = local.storage_account.id
  container_access_type = "private"
}
