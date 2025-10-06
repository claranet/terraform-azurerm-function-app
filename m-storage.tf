module "storage" {
  source  = "claranet/storage-account/azurerm"
  version = "~> 8.6.0"

  count = var.use_existing_storage_account ? 0 : 1

  location       = var.location
  location_short = var.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name

  name_prefix = local.storage_account_name_prefix
  name_suffix = format("%sfunc", var.name_suffix)

  custom_name = var.storage_account_custom_name

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
  extra_tags           = merge(local.default_tags, var.extra_tags, var.storage_account_extra_tags)
}

moved {
  from = module.linux_function[0].module.storage[0]
  to   = module.storage[0]
}
