module "storage" {
  source  = "claranet/storage-account/azurerm"
  version = "7.3.0"

  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack
  location       = var.location
  location_short = var.location_short

  resource_group_name = var.resource_group_name

  storage_account_custom_name = local.storage_account_name

  # Storage account kind/SKU/tier
  account_kind             = var.storage_account_kind
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Storage account options / security
  min_tls_version                    = var.storage_account_min_tls_version
  https_traffic_only_enabled         = var.storage_account_enable_https_traffic_only
  public_nested_items_allowed        = false
  advanced_threat_protection_enabled = var.storage_account_enable_advanced_threat_protection

  # Identity
  identity_type = var.storage_account_identity_type
  identity_ids  = var.storage_account_identity_ids

  # Data protection - not needed for functions
  storage_blob_data_protection = {
    change_feed_enabled                       = false
    versioning_enabled                        = false
    delete_retention_policy_in_days           = 0
    container_delete_retention_policy_in_days = 0
    container_point_in_time_restore           = false
  }

  # Network rules - handle out of module to avoid Terraform cycle
  network_rules_enabled = false

  # Diagnostics/logs
  logs_destinations_ids   = var.logs_destinations_ids
  logs_categories         = var.logs_categories
  logs_metrics_categories = var.logs_metrics_categories
  logs_retention_days     = var.logs_retention_days

  # Tagging
  default_tags_enabled = var.default_tags_enabled
  extra_tags = merge(
    local.default_tags,
    var.storage_account_extra_tags,
    var.extra_tags,
  )

  for_each = toset(var.storage_account_access_key == null ? ["enabled"] : [])
}

resource "azurerm_storage_account_network_rules" "storage_network_rules" {
  for_each = toset(var.storage_account_access_key == null && var.storage_account_network_rules_enabled ? ["enabled"] : [])

  storage_account_id = local.storage_account_output.id

  default_action             = "Deny"
  ip_rules                   = local.storage_ips
  virtual_network_subnet_ids = distinct(compact(concat(var.authorized_subnet_ids, [var.function_app_vnet_integration_subnet_id])))
  bypass                     = var.storage_account_network_bypass

  lifecycle {
    precondition {
      condition     = var.function_app_vnet_integration_subnet_id != null
      error_message = "Network rules on Storage Account cannot be set for same region Storage without VNet integration."
    }
  }
}

data "azurerm_storage_account" "storage" {
  name                = local.storage_account_name
  resource_group_name = var.resource_group_name

  depends_on = [module.storage]
}

resource "azurerm_storage_container" "package_container" {
  count = var.application_zip_package_path != null && local.is_local_zip ? 1 : 0

  name                  = "functions-packages"
  storage_account_name  = data.azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "package_blob" {
  count = var.application_zip_package_path != null && local.is_local_zip ? 1 : 0

  name                   = "${local.function_app_name}.zip"
  storage_account_name   = azurerm_storage_container.package_container[0].storage_account_name
  storage_container_name = azurerm_storage_container.package_container[0].name
  type                   = "Block"
  source                 = var.application_zip_package_path
  content_md5            = filemd5(var.application_zip_package_path)
}

data "azurerm_storage_account_sas" "package_sas" {
  connection_string = data.azurerm_storage_account.storage.primary_connection_string
  https_only        = false
  resource_types {
    service   = false
    container = false
    object    = true
  }
  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }
  start  = "2021-01-01"
  expiry = "2041-01-01"
  permissions {
    read    = true
    write   = false
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
    filter  = false
    tag     = false
  }
}
