module "vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  cidrs = local.vnet_cidr[*]

  extra_tags = {
    foo = "bar"
  }
}

module "subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  for_each = {
    for subnet in local.subnets : subnet.name => subnet
  }

  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  custom_name = each.key

  virtual_network_name = module.vnet.name

  service_endpoints = each.value.service_endpoints
  delegations = {
    "app-service-plan" = [{
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }]
  }

  cidrs = each.value.cidrs
}

### Linux with VNet integration
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

  vnet_integration_subnet_id = module.subnet["subnet-function-app"].id

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
