data "azurerm_client_config" "current" {}

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
  source  = "claranet/run/azurerm//modules/logs"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

module "storage_account" {
  source  = "claranet/storage-account/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  # The `storage_use_azuread=true` flag is mandatory in the provider declaration for this feature
  shared_access_key_enabled = false

  # Network rules cannot be enabled with consumption function
  network_rules_enabled = false

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id
  ]

  extra_tags = {
    foo = "bar"
  }
}

resource "azurerm_role_assignment" "user_storage" {
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = module.storage_account.storage_account_id
  role_definition_name = "Storage Blob Data Owner"
}

module "function_app" {
  source  = "claranet/function-app/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

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

  storage_uses_managed_identity = true

  use_existing_storage_account = true
  storage_account_id           = module.storage_account.storage_account_id

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id
  ]

  extra_tags = {
    foo = "bar"
  }
}

resource "azurerm_role_assignment" "function_storage" {
  principal_id         = module.function_app.linux_function_app.function_app_identity.principal_id
  scope                = module.storage_account.storage_account_id
  role_definition_name = "Storage Blob Data Owner"
}
