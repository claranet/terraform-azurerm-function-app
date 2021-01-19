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
        python = "PYTHON|3.7"
        node   = "NODE|10"
        dotnet = "DOTNET|2.2"
      },
      "v3" = {
        python = "PYTHON|3.8"
        node   = "NODE|12"
        dotnet = "DOTNET|3.1"
      }
    }
  }

  plan_kind        = data.azurerm_app_service_plan.plan.kind
  linux_fx_version = try(local.linux_version_map[data.azurerm_app_service_plan.plan.kind]["v${var.function_app_version}"][var.function_language_for_linux], "")

  default_site_config = {
    always_on        = data.azurerm_app_service_plan.plan.sku[0].tier == "Dynamic" ? false : true
    linux_fx_version = local.linux_fx_version
    ip_restriction   = concat(local.subnets, local.cidrs)
  }

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
  storage_default_name = substr(
    local.storage_default_name_long,
    0,
    length(local.storage_default_name_long) > 24 ? 23 : -1,
  )

  app_insights = try(data.azurerm_application_insights.app_insights.0, try(azurerm_application_insights.app_insights.0, {}))

  default_application_settings = merge({
    FUNCTIONS_WORKER_RUNTIME = var.function_language_for_linux
    }, var.application_insights_enabled ? {
    APPLICATION_INSIGHTS_IKEY             = try(local.app_insights.instrumentation_key, "")
    APPINSIGHTS_INSTRUMENTATIONKEY        = try(local.app_insights.instrumentation_key, "")
    APPLICATIONINSIGHTS_CONNECTION_STRING = try(local.app_insights.connection_string, "")
    } : {}
  )

  cidrs = [for cidr in var.authorized_ips : {
    name                      = "ip_restriction_cidr_${join("", [1, index(var.authorized_ips, cidr)])}"
    ip_address                = cidr
    virtual_network_subnet_id = null
    subnet_id                 = null
    priority                  = join("", [1, index(var.authorized_ips, cidr)])
    action                    = "Allow"
  }]

  subnets = [for subnet in var.authorized_subnet_ids : {
    name                      = "ip_restriction_subnet_${join("", [1, index(var.authorized_subnet_ids, subnet)])}"
    ip_address                = null
    virtual_network_subnet_id = subnet
    subnet_id                 = subnet
    priority                  = join("", [1, index(var.authorized_subnet_ids, subnet)])
    action                    = "Allow"
  }]
}
