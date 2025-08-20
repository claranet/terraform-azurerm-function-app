# Consolidated locals from submodules

locals {
  # Naming locals/constants
  name_suffix = lower(var.name_suffix)
  name_prefix = lower(var.name_prefix)

  function_app_name_prefix         = var.function_app_name_prefix == "" ? local.name_prefix : lower(var.function_app_name_prefix)
  application_insights_name_prefix = var.application_insights_name_prefix == "" ? local.name_prefix : lower(var.application_insights_name_prefix)
  storage_account_name_prefix      = var.storage_account_name_prefix == "" ? local.name_prefix : lower(var.storage_account_name_prefix)

  app_insights_name = coalesce(var.application_insights_custom_name, data.azurecaf_name.application_insights.result)
  function_app_name = coalesce(var.function_app_custom_name, data.azurecaf_name.function_app.result)
  staging_slot_name = coalesce(var.staging_slot_custom_name, "staging-slot")

  # Service plan type detection (Linux/Windows only)
  is_consumption     = lower(var.os_type) != "flex" ? contains(["Y1"], data.azurerm_service_plan.main.sku_name) : false
  is_elastic_premium = lower(var.os_type) != "flex" ? contains(["EP1", "EP2", "EP3"], data.azurerm_service_plan.main.sku_name) : false

  # Application Insights reference
  app_insights = try(data.azurerm_application_insights.main[0], one(azurerm_application_insights.main[*]))

  # Site config - conditional based on OS type
  default_site_config = lower(var.os_type) == "flex" ? {
    application_insights_connection_string = var.application_insights_enabled ? local.app_insights.connection_string : null
    application_insights_key               = var.application_insights_enabled ? local.app_insights.instrumentation_key : null
    } : {
    always_on                              = !local.is_consumption && !local.is_elastic_premium
    application_insights_connection_string = var.application_insights_enabled ? local.app_insights.connection_string : null
    application_insights_key               = var.application_insights_enabled ? local.app_insights.instrumentation_key : null
  }

  site_config = merge(local.default_site_config, var.site_config)

  # Application settings - conditional based on OS type
  default_application_settings = merge(
    var.application_zip_package_path != null ? {
      # MD5 as query to force function restart on change
      WEBSITE_RUN_FROM_PACKAGE = local.zip_package_url
    } : {},
    # Linux-specific Docker settings
    lower(var.os_type) == "linux" && substr(lookup(local.site_config, "linux_fx_version", ""), 0, 7) == "DOCKER|" ? {
      FUNCTIONS_WORKER_RUNTIME            = null
      WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    } : {},
    # Python isolation settings (Linux/Windows)
    lower(var.os_type) != "flex" && try(local.site_config.application_stack.python_version != null, false) ? {
      PYTHON_ISOLATE_WORKER_DEPENDENCIES = 1
    } : {},
    # External app settings (Linux/Windows only)
    lower(var.os_type) != "flex" ? try(data.external.function_app_settings[0].result, {}) : {},
    # Flex-specific storage settings
    lower(var.os_type) == "flex" && !var.storage_uses_managed_identity ? {
      AzureWebJobsStorage = data.azurerm_storage_account.main.primary_connection_string
    } : {}
  )

  # IP restriction logic
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

  # SCM IP restrictions
  scm_cidrs = [for cidr in var.scm_allowed_ips : {
    name                      = "scm_ip_restriction_cidr_${join("", [1, index(var.scm_allowed_ips, cidr)])}"
    ip_address                = cidr
    virtual_network_subnet_id = null
    service_tag               = null
    priority                  = join("", [1, index(var.scm_allowed_ips, cidr)])
    action                    = "Allow"
    headers                   = var.scm_ip_restriction_headers != null ? [merge(local.default_ip_restrictions_headers, var.scm_ip_restriction_headers)] : []
  }]

  scm_subnets = [for subnet in var.scm_allowed_subnet_ids : {
    name                      = "scm_ip_restriction_subnet_${join("", [1, index(var.scm_allowed_subnet_ids, subnet)])}"
    ip_address                = null
    virtual_network_subnet_id = subnet
    service_tag               = null
    priority                  = join("", [1, index(var.scm_allowed_subnet_ids, subnet)])
    action                    = "Allow"
    headers                   = var.scm_ip_restriction_headers != null ? [merge(local.default_ip_restrictions_headers, var.scm_ip_restriction_headers)] : []
  }]

  scm_service_tags = [for service_tag in var.scm_allowed_service_tags : {
    name                      = "scm_service_tag_restriction_${join("", [1, index(var.scm_allowed_service_tags, service_tag)])}"
    ip_address                = null
    virtual_network_subnet_id = null
    service_tag               = service_tag
    priority                  = join("", [1, index(var.scm_allowed_service_tags, service_tag)])
    action                    = "Allow"
    headers                   = var.scm_ip_restriction_headers != null ? [merge(local.default_ip_restrictions_headers, var.scm_ip_restriction_headers)] : []
  }]

  # Auth settings v2 logic
  auth_settings_v2 = var.auth_settings_v2

  auth_settings_v2_login = try(var.auth_settings_v2.login, {})

  # ZIP package URL logic
  zip_package_url = var.application_zip_package_path != null ? (
    can(regex("^https?://", var.application_zip_package_path)) ?
    var.application_zip_package_path :
    "${data.azurerm_storage_account.main.primary_blob_endpoint}${azurerm_storage_container.package_container[0].name}/${azurerm_storage_blob.package_blob[0].name}?${data.azurerm_storage_account_sas.package_sas[0].sas}"
  ) : null

  # Storage-related locals
  is_local_zip = length(regexall("^(http(s)?|ftp)://", var.application_zip_package_path != null ? var.application_zip_package_path : "")) == 0

  # If no VNet integration, allow Function App outbound public IPs (conditional based on OS type)
  outbound_ips = var.vnet_integration_subnet_id == null ? (
    lower(var.os_type) == "linux" ? distinct(concat(
      try(azurerm_linux_function_app.main[0].possible_outbound_ip_address_list, []),
      try(azurerm_linux_function_app.main[0].outbound_ip_address_list, [])
      )) : lower(var.os_type) == "windows" ? distinct(concat(
      try(azurerm_windows_function_app.main[0].possible_outbound_ip_address_list, []),
      try(azurerm_windows_function_app.main[0].outbound_ip_address_list, [])
    )) : []
  ) : []

  # Storage IPs for network rules
  # Small address ranges using "/31" or "/32" prefix sizes are not supported. These ranges should be configured using individual IP address rules without prefix specified.
  storage_ips = distinct(flatten([for cidr in distinct(concat(local.outbound_ips, var.storage_account_allowed_ips)) :
    length(regexall("/3[12]$", cidr)) > 0 ? [cidrhost(cidr, 0), cidrhost(cidr, -1)] : [cidr]
  ]))

  # Storage account output reference
  storage_account_output = var.use_existing_storage_account ? data.azurerm_storage_account.main : one(module.storage[*])
}
