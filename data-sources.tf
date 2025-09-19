# Data sources consolidated from submodules

data "azurerm_subscription" "current" {}

data "azurerm_storage_account" "main" {
  count = var.use_existing_storage_account ? 1 : 0

  name                = provider::azurerm::parse_resource_id(var.storage_account_id).resource_name
  resource_group_name = provider::azurerm::parse_resource_id(var.storage_account_id).resource_group_name

  lifecycle {
    precondition {
      condition     = var.storage_account_id != null
      error_message = "`var.storage_account_id` must be set when using existing Storage Account."
    }
  }
}

data "azurerm_application_insights" "main" {
  count = var.application_insights_enabled && var.use_existing_application_insights ? 1 : 0

  name                = provider::azurerm::parse_resource_id(var.application_insights_id).resource_name
  resource_group_name = provider::azurerm::parse_resource_id(var.application_insights_id).resource_group_name

  lifecycle {
    precondition {
      condition     = var.application_insights_id != null
      error_message = "`var.application_insights_id` must be set when using existing Application Insights."
    }
  }
}

data "external" "function_app_settings" {
  count = var.application_settings_drift_ignore ? 1 : 0

  program = ["bash", "${path.module}/files/webapp_setting.sh"]

  query = {
    webapp_name  = local.function_app_name
    rg_name      = var.resource_group_name
    subscription = data.azurerm_subscription.current.subscription_id
  }
}

data "azurerm_storage_account_sas" "package_sas" {
  count = var.application_zip_package_path != null && !var.storage_uses_managed_identity ? 1 : 0

  connection_string = local.storage_account.primary_connection_string
  https_only        = false

  resource_types {
    service   = false
    container = false
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2021-01-01"
  expiry = "2041-01-01"

  permissions {
    read    = true
    write   = false
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
    filter  = false
    tag     = false
  }
}
