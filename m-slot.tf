module "staging_slot" {
  count = var.staging_slot_enabled && !local.is_linux_flex ? 1 : 0

  source = "./modules/slot"

  # Required variables
  name            = var.staging_slot_custom_name
  slot_os_type    = var.os_type
  function_app_id = local.function_app.id
  environment     = var.environment
  stack           = var.stack

  # Storage configuration
  storage_account_name          = local.storage_account.name
  storage_account_access_key    = !var.storage_uses_managed_identity ? local.storage_account.primary_access_key : null
  storage_uses_managed_identity = var.storage_uses_managed_identity

  # Function App configuration
  functions_extension_version = "~${var.function_app_version}"

  # Site configuration
  site_config = local.site_config

  # Application settings
  app_settings = var.staging_slot_custom_application_settings == null ? {
    for key, value in local.application_settings : key => value if key != "WEBSITE_RUN_FROM_PACKAGE"
  } : local.staging_slot_application_settings

  # Authentication settings
  auth_settings_v2       = var.auth_settings_v2
  auth_settings_v2_login = local.auth_settings_v2_login

  # Network configuration
  public_network_access_enabled = var.public_network_access_enabled
  vnet_integration_subnet_id    = var.vnet_integration_subnet_id

  # IP restrictions
  ip_restriction         = concat(local.subnets, local.cidrs, local.service_tags)
  scm_ip_restriction     = concat(local.scm_subnets, local.scm_cidrs, local.scm_service_tags)
  scm_allowed_cidrs      = var.scm_allowed_ips
  scm_allowed_subnet_ids = var.scm_allowed_subnet_ids

  # Security settings
  https_only                 = var.https_only
  client_certificate_enabled = var.client_certificate_enabled
  client_certificate_mode    = var.client_certificate_mode
  builtin_logging_enabled    = var.builtin_logging_enabled

  # Identity configuration
  identity = {
    type         = var.identity_type
    identity_ids = endswith(var.identity_type, "UserAssigned") ? var.identity_ids : []
  }

  # Storage mount points
  mount_points = length(var.staging_slot_mount_points) > 0 ? var.staging_slot_mount_points : var.mount_points

  # Tags
  default_tags_enabled = var.default_tags_enabled
  extra_tags           = merge(local.default_tags, var.extra_tags, var.function_app_extra_tags)
}
