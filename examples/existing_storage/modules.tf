data "azurerm_client_config" "current" {}

module "storage_account" {
  source  = "claranet/storage-account/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  # The `storage_use_azuread=true` flag is mandatory in the provider declaration for this feature
  shared_access_key_enabled = false

  # Network rules cannot be enabled with consumption function
  network_rules_enabled = false

  logs_destinations_ids = []

  extra_tags = {
    foo = "bar"
  }
}

resource "azurerm_role_assignment" "user_storage" {
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = module.storage_account.id
  role_definition_name = "Storage Blob Data Owner"
}

module "function_app" {
  source  = "claranet/function-app/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

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

  storage_uses_managed_identity = true

  use_existing_storage_account = true
  storage_account_id           = module.storage_account.id

  logs_destinations_ids = []

  extra_tags = {
    foo = "bar"
  }
}

resource "azurerm_role_assignment" "function_storage" {
  principal_id         = module.function_app.identity_principal_id
  scope                = module.storage_account.id
  role_definition_name = "Storage Blob Data Owner"
}
