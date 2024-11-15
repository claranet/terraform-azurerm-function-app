### Linux
module "function_app_linux" {
  source  = "claranet/function-app/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.name

  name_prefix = "hello"

  os_type              = "Linux"
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

  storage_account_identity_type = "SystemAssigned"

  # application_insights_log_analytics_workspace_id = module.logs.log_analytics_workspace_id

  logs_destinations_ids = [
    # module.logs.logs_storage_account_id,
    # module.logs.log_analytics_workspace_id
  ]

  extra_tags = {
    foo = "bar"
  }
}
