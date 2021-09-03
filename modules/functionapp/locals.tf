locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

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

  linux_fx_version = try(local.linux_version_map[lower(data.azurerm_app_service_plan.plan.kind)]["v${var.function_app_version}"][lower(var.function_language_for_linux)], "")

  default_site_config = {
    always_on        = data.azurerm_app_service_plan.plan.sku[0].tier == "Dynamic" ? false : true
    linux_fx_version = local.linux_fx_version
    ip_restriction   = concat(local.subnets, local.cidrs, local.service_tags)
  }
  site_config = merge(local.default_site_config, var.site_config)

  name_prefix          = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""
  ai_name_prefix       = var.application_insights_name_prefix != "" ? replace(var.application_insights_name_prefix, "/[a-z0-9]$/", "$0-") : local.name_prefix
  function_name_prefix = var.function_app_name_prefix != "" ? replace(var.function_app_name_prefix, "/[a-z0-9]$/", "$0-") : local.name_prefix
  sa_name_prefix       = var.storage_account_name_prefix != "" ? replace(var.storage_account_name_prefix, "/[a-z0-9]$/", "$0-") : local.name_prefix

  function_default_name             = "${local.function_name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-func"
  application_insights_default_name = "${local.ai_name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-ai"

  storage_default_name_long = replace(
    format(
      "%s%s%s",
      local.sa_name_prefix,
      var.stack,
      var.environment,
    ),
    "/[._-]/",
    "",
  )
  # Force user to set storage name if key is set
  storage_default_name = var.storage_account_access_key == null ? substr(
    local.storage_default_name_long,
    0,
    length(local.storage_default_name_long) > 24 ? 23 : -1,
  ) : null

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

  cidrs = [for cidr in var.authorized_ips : {
    name                      = "ip_restriction_cidr_${join("", [1, index(var.authorized_ips, cidr)])}"
    ip_address                = cidr
    virtual_network_subnet_id = null
    service_tag               = null
    subnet_id                 = null
    priority                  = join("", [1, index(var.authorized_ips, cidr)])
    action                    = "Allow"
  }]

  subnets = [for subnet in var.authorized_subnet_ids : {
    name                      = "ip_restriction_subnet_${join("", [1, index(var.authorized_subnet_ids, subnet)])}"
    ip_address                = null
    virtual_network_subnet_id = subnet
    service_tag               = null
    subnet_id                 = subnet
    priority                  = join("", [1, index(var.authorized_subnet_ids, subnet)])
    action                    = "Allow"
  }]

  service_tags = [for service_tag in var.authorized_service_tags : {
    name                      = "service_tag_restriction_${join("", [1, index(var.authorized_service_tags, service_tag)])}"
    ip_address                = null
    virtual_network_subnet_id = null
    service_tag               = service_tag
    subnet_id                 = null
    priority                  = join("", [1, index(var.authorized_service_tags, service_tag)])
    action                    = "Allow"
  }]

  is_local_zip    = length(regexall("^(http(s)?|ftp)://", var.application_zip_package_path != null ? var.application_zip_package_path : 0)) == 0
  zip_package_url = var.application_zip_package_path != null && local.is_local_zip ? format("%s%s&md5=%s", azurerm_storage_blob.package_blob[0].url, data.azurerm_storage_account_sas.package_sas.sas, filemd5(var.application_zip_package_path)) : var.application_zip_package_path
}
