module "vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name = module.rg.name
  cidrs               = [local.vnet_cidr]
}

# module "subnet" {
#   source  = "claranet/subnet/azurerm"
#   version = "x.x.x"

#   for_each = { for subnet in local.subnets : subnet.name => subnet }

#   environment    = var.environment
#   location_short = module.azure_region.location_short
#   client_name    = var.client_name
#   stack          = var.stack

#   custom_subnet_name = each.key

#   resource_group_name  = module.rg.name
#   virtual_network_name = module.vnet.name
#   cidrs                = each.value.cidrs

#   service_endpoints = each.value.service_endpoints

#   subnet_delegation = {
#     app-service-plan = [
#       {
#         name    = "Microsoft.Web/serverFarms"
#         actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
#       }
#     ]
#   }
# }

### Linux with VNET integration
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

  # function_app_vnet_integration_subnet_id = module.subnet["subnet-function-app"].subnet_id

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
