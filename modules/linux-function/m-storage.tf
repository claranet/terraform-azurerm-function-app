moved {
  from = module.storage["enabled"]
  to   = module.storage[0]
}

module "storage" {
  count = var.use_existing_storage_account ? 0 : 1

  #   source  = "claranet/storage-account/azurerm"
  #   version = "~> 8.6.0"
  source = "git@git.fr.clara.net:claranet/projects/cloud/azure/terraform/modules/storage-account.git?ref=fix/threat_protect"

  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack
  location       = var.location
  location_short = var.location_short

  resource_group_name = var.resource_group_name

  custom_name = var.storage_account_custom_name
  name_prefix = local.storage_account_name_prefix
  name_suffix = format("%sfunc", var.name_suffix)

  # Storage account kind/SKU/tier
  account_kind             = var.storage_account_kind
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Storage account options / security
  min_tls_version                    = var.storage_account_min_tls_version
  https_traffic_only_enabled         = var.storage_account_https_traffic_only_enabled
  public_nested_items_allowed        = false
  advanced_threat_protection_enabled = var.storage_account_advanced_threat_protection_enabled
  shared_access_key_enabled          = !var.storage_uses_managed_identity
  infrastructure_encryption_enabled  = var.storage_account_infrastructure_encryption_enabled

  # RBAC
  rbac_storage_contributor_role_principal_ids       = var.rbac_storage_contributor_role_principal_ids
  rbac_storage_blob_role_principal_ids              = var.rbac_storage_blob_role_principal_ids
  rbac_storage_file_role_principal_ids              = var.rbac_storage_file_role_principal_ids
  rbac_storage_table_role_principal_ids             = var.rbac_storage_table_role_principal_ids
  rbac_storage_queue_contributor_role_principal_ids = var.rbac_storage_queue_contributor_role_principal_ids

  # Identity
  identity_type = var.storage_account_identity_type
  identity_ids  = var.storage_account_identity_ids

  # Data protection - not needed for functions
  blob_data_protection = {
    change_feed_enabled                       = false
    versioning_enabled                        = false
    delete_retention_policy_in_days           = 0
    container_delete_retention_policy_in_days = 0
    container_point_in_time_restore           = false
  }

  # Network rules - handle out of module to avoid Terraform cycle
  network_rules_enabled = false

  # Diagnostics/logs
  logs_destinations_ids   = var.storage_logs_destinations_ids != null ? var.storage_logs_destinations_ids : var.logs_destinations_ids
  logs_categories         = var.storage_logs_categories != null ? var.storage_logs_categories : var.logs_categories
  logs_metrics_categories = var.storage_logs_metrics_categories != null ? var.storage_logs_metrics_categories : var.logs_metrics_categories

  # Tagging
  default_tags_enabled = var.default_tags_enabled
  extra_tags = merge(
    local.default_tags,
    var.storage_account_extra_tags,
    var.extra_tags,
  )
}

moved {
  from = azurerm_storage_account_network_rules.storage_network_rules["enabled"]
  to   = azurerm_storage_account_network_rules.main[0]
}

resource "azurerm_storage_account_network_rules" "main" {
  count = !var.use_existing_storage_account && var.storage_account_network_rules_enabled ? 1 : 0

  storage_account_id = local.storage_account_output.id

  default_action             = "Deny"
  ip_rules                   = local.storage_ips
  virtual_network_subnet_ids = distinct(compact(concat(var.allowed_subnet_ids, [var.vnet_integration_subnet_id])))
  bypass                     = var.storage_account_network_bypass

  lifecycle {
    precondition {
      condition     = var.vnet_integration_subnet_id != null
      error_message = "Network rules on Storage Account cannot be set for same region Storage without VNet integration."
    }
  }
}

resource "azurerm_storage_container" "package_container" {
  count = var.application_zip_package_path != null && local.is_local_zip ? 1 : 0

  name                  = "functions-packages"
  storage_account_id    = data.azurerm_storage_account.main.id
  container_access_type = "private"
}

resource "azurerm_storage_blob" "package_blob" {
  count = var.application_zip_package_path != null && local.is_local_zip ? 1 : 0

  name                   = "${local.function_app_name}.zip"
  storage_account_name   = data.azurerm_storage_account.main.name
  storage_container_name = azurerm_storage_container.package_container[0].name
  type                   = "Block"
  source                 = var.application_zip_package_path
  content_md5            = filemd5(var.application_zip_package_path)
}

data "azurerm_storage_account_sas" "package_sas" {
  count = var.application_zip_package_path != null && !var.storage_uses_managed_identity ? 1 : 0

  connection_string = data.azurerm_storage_account.main.primary_connection_string
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
