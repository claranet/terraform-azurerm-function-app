### Linux
module "function_app_linux" {
  source  = "claranet/function-app/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  name_prefix = "hello"

  os_type = "Linux"

  function_app_version = 4
  site_config = {
    application_stack = {
      python_version = "3.12"
    }
  }

  application_settings = {
    "tracker_id"      = "AJKGDFJKHFDS"
    "backend_api_url" = "https://backend.domain.tld/api"
  }

  application_insights_log_analytics_workspace_id = module.logs.id

  storage_account_identity_type = "SystemAssigned"

  logs_destinations_ids = [
    module.logs.id,
    module.logs.storage_account_id,
  ]

  extra_tags = {
    foo = "bar"
  }
}

module "function_app_slot" {
  source  = "claranet/function-app/azurerm//modules/slot"
  version = "x.x.x"

  # Required variables
  name            = "staging"
  slot_os_type    = "Linux"
  function_app_id = module.function_app_linux.id

  environment = var.environment
  stack       = var.stack

  # Storage configuration
  storage_account_name          = module.function_app_linux.storage_account_name
  storage_account_access_key    = !var.storage_uses_managed_identity ? module.function_app_linux.storage_account_primary_access_key : null
  storage_uses_managed_identity = var.storage_uses_managed_identity

  # Optional configuration
  site_config = {
    always_on = true
    application_stack = {
      dotnet_version = "6.0"
    }
  }

  app_settings = {
    "ENVIRONMENT" = "staging"
  }

  # Tags
  extra_tags = {
    Purpose = "staging"
  }
}
