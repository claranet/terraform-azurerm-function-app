module "vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  cidrs = ["10.20.30.0/24"]

  extra_tags = {
    foo = "bar"
  }
}

module "subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  virtual_network_name = module.vnet.name

  service_endpoints = ["Microsoft.Storage"]
  delegations = {
    "Microsoft.App/environments" = [{
      name    = "Microsoft.App/environments" # Different from Linux/Windows Function Apps
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }]
  }

  cidrs = ["10.20.30.0/25"]
}

### Linux Flex with VNet integration
module "function_app_flex_consumption" {
  source  = "claranet/function-app/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  os_type  = "Linux"
  sku_name = "FC1"

  runtime_name    = "python"
  runtime_version = "3.12"

  storage_account_allowed_ips = ["12.34.56.78/31"]

  vnet_integration_subnet_id = module.subnet.id

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
