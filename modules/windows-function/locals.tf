locals {
  linux_version_map = {
    "linux" = {
      "v2" = {
        python = "DOCKER|mcr.microsoft.com/azure-functions/python:2.0-python3.6"
        node   = "DOCKER|mcr.microsoft.com/azure-functions/node:2.0-node8"
        dotnet = "DOCKER|mcr.microsoft.com/azure-functions/dotnet:2.0"
      },
      "v3" = {
        python = "DOCKER|mcr.microsoft.com/azure-functions/python:3.0-python3.8"
        node   = "DOCKER|mcr.microsoft.com/azure-functions/node:3.0-node12"
        dotnet = "DOCKER|mcr.microsoft.com/azure-functions/dotnet:3.0"

      }
    },
    "functionapp" = {
      "v2" = {
        python = "python|3.7"
        node   = "node|10"
        dotnet = "dotnet|2.2"
      },
      "v3" = {
        python = "python|3.8"
        node   = "node|12"
        dotnet = "dotnet|3.1"
      }
    }
  }

  linux_fx_version = try(local.linux_version_map[lower(data.azurerm_service_plan.plan.kind)]["v${var.function_app_version}"][lower(var.function_language_for_linux)], "")

  default_site_config = {
    always_on        = data.azurerm_service_plan.plan.sku_name == "Y1" ? false : true
    linux_fx_version = local.linux_fx_version
    ip_restriction   = concat(local.subnets, local.cidrs, local.service_tags)
  }

  site_config = merge(local.default_site_config, var.site_config)

  app_insights = try(data.azurerm_application_insights.app_insights[0], try(azurerm_application_insights.app_insights[0], {}))

  default_application_settings = merge({
    FUNCTIONS_WORKER_RUNTIME = var.function_language_for_linux
    },
    var.application_insights_enabled ? {
      APPLICATION_INSIGHTS_IKEY             = try(local.app_insights.instrumentation_key, "")
      APPINSIGHTS_INSTRUMENTATIONKEY        = try(local.app_insights.instrumentation_key, "")
      APPLICATIONINSIGHTS_CONNECTION_STRING = try(local.app_insights.connection_string, "")
    } : {},
    substr(lookup(local.site_config, "linux_fx_version", ""), 0, 7) == "DOCKER|" ? {
      FUNCTIONS_WORKER_RUNTIME            = null
      WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    } : {},
    var.application_zip_package_path != null ? {
      # MD5 as query to force function restart on change
      WEBSITE_RUN_FROM_PACKAGE : local.zip_package_url
    } : {}
  )

  default_ip_restrictions_headers = {
    x_azure_fdid      = null
    x_fd_health_probe = null
    x_forwarded_for   = null
    x_forwarded_host  = null
  }

  ip_restriction_headers = var.ip_restriction_headers != null ? [merge(local.default_ip_restrictions_headers, var.ip_restriction_headers)] : []

  cidrs = [for cidr in var.authorized_ips : {
    name                      = "ip_restriction_cidr_${join("", [1, index(var.authorized_ips, cidr)])}"
    ip_address                = cidr
    virtual_network_subnet_id = null
    service_tag               = null
    subnet_id                 = null
    priority                  = join("", [1, index(var.authorized_ips, cidr)])
    action                    = "Allow"
    headers                   = local.ip_restriction_headers
  }]

  subnets = [for subnet in var.authorized_subnet_ids : {
    name                      = "ip_restriction_subnet_${join("", [1, index(var.authorized_subnet_ids, subnet)])}"
    ip_address                = null
    virtual_network_subnet_id = subnet
    service_tag               = null
    subnet_id                 = subnet
    priority                  = join("", [1, index(var.authorized_subnet_ids, subnet)])
    action                    = "Allow"
    headers                   = local.ip_restriction_headers
  }]

  service_tags = [for service_tag in var.authorized_service_tags : {
    name                      = "service_tag_restriction_${join("", [1, index(var.authorized_service_tags, service_tag)])}"
    ip_address                = null
    virtual_network_subnet_id = null
    service_tag               = service_tag
    subnet_id                 = null
    priority                  = join("", [1, index(var.authorized_service_tags, service_tag)])
    action                    = "Allow"
    headers                   = local.ip_restriction_headers
  }]

  scm_ip_restriction_headers = var.scm_ip_restriction_headers != null ? [merge(local.default_ip_restrictions_headers, var.scm_ip_restriction_headers)] : []

  scm_cidrs = [for cidr in var.scm_authorized_ips : {
    name                      = "scm_ip_restriction_cidr_${join("", [1, index(var.scm_authorized_ips, cidr)])}"
    ip_address                = cidr
    virtual_network_subnet_id = null
    service_tag               = null
    subnet_id                 = null
    priority                  = join("", [1, index(var.scm_authorized_ips, cidr)])
    action                    = "Allow"
    headers                   = local.scm_ip_restriction_headers
  }]

  scm_subnets = [for subnet in var.scm_authorized_subnet_ids : {
    name                      = "scm_ip_restriction_subnet_${join("", [1, index(var.scm_authorized_subnet_ids, subnet)])}"
    ip_address                = null
    virtual_network_subnet_id = subnet
    service_tag               = null
    subnet_id                 = subnet
    priority                  = join("", [1, index(var.scm_authorized_subnet_ids, subnet)])
    action                    = "Allow"
    headers                   = local.scm_ip_restriction_headers
  }]

  scm_service_tags = [for service_tag in var.scm_authorized_service_tags : {
    name                      = "scm_service_tag_restriction_${join("", [1, index(var.scm_authorized_service_tags, service_tag)])}"
    ip_address                = null
    virtual_network_subnet_id = null
    service_tag               = service_tag
    subnet_id                 = null
    priority                  = join("", [1, index(var.scm_authorized_service_tags, service_tag)])
    action                    = "Allow"
    headers                   = local.scm_ip_restriction_headers
  }]

  # If no subnet integration, allow function-app outbound IPs
  function_out_ips = var.function_app_vnet_integration_subnet_id == null ? [] : distinct(concat(azurerm_windows_function_app.windows_function.possible_outbound_ip_addresses, azurerm_windows_function_app.windows_function.outbound_ip_addresses))
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules#ip_rules
  # > Small address ranges using "/31" or "/32" prefix sizes are not supported. These ranges should be configured using individual IP address rules without prefix specified.
  storage_ips = distinct(flatten([for cidr in distinct(concat(local.function_out_ips, var.storage_account_authorized_ips)) :
    length(regexall("/3[12]$", cidr)) > 0 ? [cidrhost(cidr, 0), cidrhost(cidr, -1)] : [cidr]
  ]))

  is_local_zip    = length(regexall("^(http(s)?|ftp)://", var.application_zip_package_path != null ? var.application_zip_package_path : 0)) == 0
  zip_package_url = var.application_zip_package_path != null && local.is_local_zip ? format("%s%s&md5=%s", azurerm_storage_blob.package_blob[0].url, data.azurerm_storage_account_sas.package_sas.sas, filemd5(var.application_zip_package_path)) : var.application_zip_package_path
}
