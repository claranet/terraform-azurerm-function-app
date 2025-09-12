# Consolidated locals from submodules

locals {
  # Service plan type detection
  is_consumption     = contains(["Y1"], module.service_plan.resource.sku_name)
  is_elastic_premium = contains(["EP1", "EP2", "EP3"], module.service_plan.resource.sku_name)
  is_linux_flex      = startswith(module.service_plan.resource.sku_name, "FC")

  # Key resource references
  function_app    = one(coalescelist(azurerm_linux_function_app.main, azurerm_windows_function_app.main, azurerm_function_app_flex_consumption.main))
  staging_slot    = var.staging_slot_enabled && !local.is_linux_flex ? one(coalescelist(azurerm_linux_function_app_slot.main, azurerm_windows_function_app_slot.main)) : null
  app_insights    = try(data.azurerm_application_insights.main[0], one(azurerm_application_insights.main))
  storage_account = try(data.azurerm_storage_account.main[0], one(module.storage[*].resource))

  # Site config
  default_site_config = merge(
    !local.is_linux_flex ? {
      always_on = !local.is_consumption && !local.is_elastic_premium
    } : {},
    {
      application_insights_connection_string = var.application_insights_enabled ? local.app_insights.connection_string : null
      application_insights_key               = var.application_insights_enabled ? local.app_insights.instrumentation_key : null
    },
  )

  site_config = merge(local.default_site_config, var.site_config)

  # Application settings
  default_application_settings = merge(
    var.application_zip_package_path != null ? {
      WEBSITE_RUN_FROM_PACKAGE = local.zip_package_url # MD5 as query to force function restart on change
    } : {},
    lower(var.os_type) == "linux" && substr(lookup(local.site_config, "linux_fx_version", ""), 0, 7) == "DOCKER|" ? {
      FUNCTIONS_WORKER_RUNTIME            = null
      WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    } : {},
    !local.is_linux_flex && try(local.site_config.application_stack.python_version != null, false) ? {
      PYTHON_ISOLATE_WORKER_DEPENDENCIES = 1
    } : {},
    local.is_linux_flex && !var.storage_uses_managed_identity ? {
      AzureWebJobsStorage = local.storage_account.primary_connection_string # This causes OpenTofu perpetual drift
    } : {},
    try(one(data.external.function_app_settings[*].result), {}), # Used to avoid drift
  )

  application_settings = merge(local.default_application_settings, var.application_settings)
  staging_slot_application_settings = {
    for key, value in merge(local.default_application_settings, var.staging_slot_custom_application_settings) : key => value if key != "WEBSITE_RUN_FROM_PACKAGE"
  }

  # IP restriction logic
  cidrs = [
    for cidr in var.allowed_ips : {
      name                      = "ip_restriction_cidr_${join("", ["1", index(var.allowed_ips, cidr)])}"
      ip_address                = cidr
      virtual_network_subnet_id = null
      service_tag               = null
      priority                  = join("", ["1", index(var.allowed_ips, cidr)])
      action                    = "Allow"
    }
  ]
  subnets = [
    for subnet in var.allowed_subnet_ids : {
      name                      = "ip_restriction_subnet_${join("", ["1", index(var.allowed_subnet_ids, subnet)])}"
      ip_address                = null
      virtual_network_subnet_id = subnet
      service_tag               = null
      priority                  = join("", ["1", index(var.allowed_subnet_ids, subnet)])
      action                    = "Allow"
    }
  ]
  service_tags = [
    for service_tag in var.allowed_service_tags : {
      name                      = "service_tag_restriction_${join("", ["1", index(var.allowed_service_tags, service_tag)])}"
      ip_address                = null
      virtual_network_subnet_id = null
      service_tag               = service_tag
      priority                  = join("", ["1", index(var.allowed_service_tags, service_tag)])
      action                    = "Allow"
    }
  ]

  scm_cidrs = [
    for cidr in var.scm_allowed_ips : {
      name                      = "scm_ip_restriction_cidr_${join("", ["1", index(var.scm_allowed_ips, cidr)])}"
      ip_address                = cidr
      virtual_network_subnet_id = null
      service_tag               = null
      priority                  = join("", ["1", index(var.scm_allowed_ips, cidr)])
      action                    = "Allow"
    }
  ]
  scm_subnets = [
    for subnet in var.scm_allowed_subnet_ids : {
      name                      = "scm_ip_restriction_subnet_${join("", ["1", index(var.scm_allowed_subnet_ids, subnet)])}"
      ip_address                = null
      virtual_network_subnet_id = subnet
      service_tag               = null
      priority                  = join("", ["1", index(var.scm_allowed_subnet_ids, subnet)])
      action                    = "Allow"
    }
  ]
  scm_service_tags = [
    for service_tag in var.scm_allowed_service_tags : {
      name                      = "scm_service_tag_restriction_${join("", ["1", index(var.scm_allowed_service_tags, service_tag)])}"
      ip_address                = null
      virtual_network_subnet_id = null
      service_tag               = service_tag
      priority                  = join("", ["1", index(var.scm_allowed_service_tags, service_tag)])
      action                    = "Allow"
    }
  ]

  # Auth settings
  auth_settings_v2_login = lookup(var.auth_settings_v2, "login", {})

  # ZIP package URL logic
  is_local_zip = length(regexall("^(http(s)?|ftp)://", var.application_zip_package_path != null ? var.application_zip_package_path : "")) == 0
  zip_package_url = var.application_zip_package_path != null ? (
    can(regex("^https?://", var.application_zip_package_path)) ? var.application_zip_package_path :
    format("%s%s/%s?%s}",
      local.storage_account.primary_blob_endpoint,
      one(azurerm_storage_container.package_container[*].name),
      one(azurerm_storage_blob.package_blob[*].name),
      one(data.azurerm_storage_account_sas.package_sas[*].sas),
    )
  ) : null

  # If no VNet integration, allow Function App outbound public IPs
  function_app_outbound_ips = var.vnet_integration_subnet_id == null ? concat(
    local.function_app.possible_outbound_ip_address_list,
    local.function_app.outbound_ip_address_list,
  ) : []

  # Storage IPs for network rules
  # Small address ranges using "/31" or "/32" prefix sizes are not supported. These ranges should be configured using individual IP address rules without prefix specified.
  storage_account_allowed_ips = distinct(flatten([
    for cidr in distinct(concat(local.function_app_outbound_ips, var.storage_account_allowed_ips)) : length(regexall("/3[12]$", cidr)) > 0 ? [cidrhost(cidr, 0), cidrhost(cidr, -1)] : cidr[*]
  ]))
}
