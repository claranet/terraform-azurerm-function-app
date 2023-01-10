module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

### Windows
module "function_app_windows" {
  source  = "claranet/function-app/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  name_prefix = "hello"

  os_type = "Windows"

  function_app_application_settings = {
    "tracker_id"      = "AJKGDFJKHFDS"
    "backend_api_url" = "https://backend.domain.tld/api"
  }

  storage_account_identity_type = "SystemAssigned"

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id
  ]

  extra_tags = {
    foo = "bar"
  }
}

### Linux
module "function_app_linux" {
  source  = "claranet/function-app/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  name_prefix = "hello"

  os_type              = "Linux"
  function_app_version = 4
  function_app_site_config = {
    application_stack = {
      python_version = "3.9"
    }
  }

  function_app_application_settings = {
    "tracker_id"      = "AJKGDFJKHFDS"
    "backend_api_url" = "https://backend.domain.tld/api"
  }

  storage_account_identity_type = "SystemAssigned"

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id
  ]

  extra_tags = {
    foo = "bar"
  }
}
