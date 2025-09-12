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

  application_insights_enabled = false

  storage_account_identity_type = "SystemAssigned"

  logs_destinations_ids = []

  extra_tags = {
    foo = "bar"
  }
}
