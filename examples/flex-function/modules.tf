module "function_app_flex_consumption" {
  source  = "claranet/function-app/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  name_prefix = "hello"

  os_type  = "Linux"
  sku_name = "FC1"

  runtime_name    = "python"
  runtime_version = "3.12"

  maximum_instance_count = 101

  # The total number of `instance_count` should not exceed the `maximum_instance_count`
  always_ready_functions = [
    {
      name           = "function:foo"
      instance_count = 10
    },
    {
      name           = "function:bar"
      instance_count = 20
    },
    {
      name           = "http" # Predefined function groups: `http`, `blob` and `durable`
      instance_count = 30
    },
  ]

  application_settings = {
    "tracker_id"      = "AJKGDFJKHFDS"
    "backend_api_url" = "https://backend.domain.tld/api"
  }

  application_insights_log_analytics_workspace_id = module.logs.id

  logs_destinations_ids = [
    module.logs.id,
    module.logs.storage_account_id,
  ]

  extra_tags = {
    foo = "bar"
  }
}
