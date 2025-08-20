### Flex
module "function_app_flex_consumption" {
  source  = "claranet/function-app/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.name

  name_prefix = "hello"

  os_type = "Flex"

  runtime_name                  = "python"
  runtime_version               = "3.12"
  storage_uses_managed_identity = true

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
