locals {
  is_consumption     = contains(["Y1"], data.azurerm_service_plan.main.sku_name)
  is_elastic_premium = contains(["EP1", "EP2", "EP3"], data.azurerm_service_plan.main.sku_name)

  default_site_config = {
    always_on                              = !local.is_consumption && !local.is_elastic_premium
    application_insights_connection_string = var.application_insights_enabled ? local.app_insights.connection_string : null
    application_insights_key               = var.application_insights_enabled ? local.app_insights.instrumentation_key : null
  }

  site_config = merge(local.default_site_config, var.site_config)

  app_insights = try(data.azurerm_application_insights.main[0], one(azurerm_application_insights.main[*]))

  default_application_settings = merge(
    var.application_zip_package_path != null ? {
      # MD5 as query to force function restart on change
      WEBSITE_RUN_FROM_PACKAGE = local.zip_package_url
    } : {},
    try(local.site_config.application_stack.python_version != null, false) ? { PYTHON_ISOLATE_WORKER_DEPENDENCIES = 1 } : {},
    try(data.external.function_app_settings[0].result, {}),
  )

  default_ip_restrictions_headers = {
    x_azure_fdid      = null
    x_fd_health_probe = null
    x_forwarded_for   = null
    x_forwarded_host  = null
  }

  ip_restriction_headers = var.ip_restriction_headers != null ? [merge(local.default_ip_restrictions_headers, var.ip_restriction_headers)] : []

  cidrs = [for cidr in var.allowed_ips : {
    name                      = "ip_restriction_cidr_${join("", [1, index(var.allowed_ips, cidr)])}"
    ip_address                = cidr
    virtual_network_subnet_id = null
    service_tag               = null
    priority                  = join("", [1, index(var.allowed_ips, cidr)])
    action                    = "Allow"
    headers                   = local.ip_restriction_headers
  }]

  subnets = [for subnet in var.allowed_subnet_ids : {
    name                      = "ip_restriction_subnet_${join("", [1, index(var.allowed_subnet_ids, subnet)])}"
    ip_address                = null
    virtual_network_subnet_id = subnet
    service_tag               = null
    priority                  = join("", [1, index(var.allowed_subnet_ids, subnet)])
    action                    = "Allow"
    headers                   = local.ip_restriction_headers
  }]

  service_tags = [for service_tag in var.allowed_service_tags : {
    name                      = "service_tag_restriction_${join("", [1, index(var.allowed_service_tags, service_tag)])}"
    ip_address                = null
    virtual_network_subnet_id = null
    service_tag               = service_tag
    priority                  = join("", [1, index(var.allowed_service_tags, service_tag)])
    action                    = "Allow"
    headers                   = local.ip_restriction_headers
  }]

  scm_ip_restriction_headers = var.scm_ip_restriction_headers != null ? [merge(local.default_ip_restrictions_headers, var.scm_ip_restriction_headers)] : []

  scm_cidrs = [for cidr in var.scm_allowed_ips : {
    name                      = "scm_ip_restriction_cidr_${join("", [1, index(var.scm_allowed_ips, cidr)])}"
    ip_address                = cidr
    virtual_network_subnet_id = null
    service_tag               = null
    priority                  = join("", [1, index(var.scm_allowed_ips, cidr)])
    action                    = "Allow"
    headers                   = local.scm_ip_restriction_headers
  }]

  scm_subnets = [for subnet in var.scm_allowed_subnet_ids : {
    name                      = "scm_ip_restriction_subnet_${join("", [1, index(var.scm_allowed_subnet_ids, subnet)])}"
    ip_address                = null
    virtual_network_subnet_id = subnet
    service_tag               = null
    priority                  = join("", [1, index(var.scm_allowed_subnet_ids, subnet)])
    action                    = "Allow"
    headers                   = local.scm_ip_restriction_headers
  }]

  scm_service_tags = [for service_tag in var.scm_allowed_service_tags : {
    name                      = "scm_service_tag_restriction_${join("", [1, index(var.scm_allowed_service_tags, service_tag)])}"
    ip_address                = null
    virtual_network_subnet_id = null
    service_tag               = service_tag
    priority                  = join("", [1, index(var.scm_allowed_service_tags, service_tag)])
    action                    = "Allow"
    headers                   = local.scm_ip_restriction_headers
  }]

  # If no VNet integration, allow Function App outbound public IPs
  outbound_ips = var.vnet_integration_subnet_id == null ? distinct(concat(azurerm_windows_function_app.main.possible_outbound_ip_address_list, azurerm_windows_function_app.main.outbound_ip_address_list)) : []

  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules#ip_rules
  # > Small address ranges using "/31" or "/32" prefix sizes are not supported. These ranges should be configured using individual IP address rules without prefix specified.
  storage_ips = distinct(flatten([for cidr in distinct(concat(local.outbound_ips, var.storage_account_allowed_ips)) :
    length(regexall("/3[12]$", cidr)) > 0 ? [cidrhost(cidr, 0), cidrhost(cidr, -1)] : [cidr]
  ]))

  is_local_zip = length(regexall("^(http(s)?|ftp)://", var.application_zip_package_path != null ? var.application_zip_package_path : 0)) == 0
  zip_package_url = (
    var.application_zip_package_path != null && local.is_local_zip ?
    format("%s%s&md5=%s", azurerm_storage_blob.package_blob[0].url, try(data.azurerm_storage_account_sas.package_sas["enabled"].sas, "?"), filemd5(var.application_zip_package_path)) :
    var.application_zip_package_path
  )

  storage_account_output = data.azurerm_storage_account.main

  auth_settings_v2 = merge({
    auth_enabled = false
  }, var.auth_settings_v2)

  auth_settings_v2_login_default = {
    token_store_enabled               = false
    token_refresh_extension_time      = 72
    preserve_url_fragments_for_logins = false
    cookie_expiration_convention      = "FixedTime"
    cookie_expiration_time            = "08:00:00"
    validate_nonce                    = true
    nonce_expiration_time             = "00:05:00"
  }

  auth_settings_v2_login = try(var.auth_settings_v2.login, local.auth_settings_v2_login_default)
}
