# Azure Function App
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/function-app-single/azurerm/)

This Terraform feature creates an [Azure Function App](https://docs.microsoft.com/en-us/azure/azure-functions/).
A [Storage Account](https://docs.microsoft.com/en-us/azure/storage/) and an [Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) 
are required and are created if not provided. An [App Service Plan](https://docs.microsoft.com/en-us/azure/app-service/overview-hosting-plans)
must be provided for hosting.

## Version compatibility

| Module version | Terraform version | AzureRM version |
|----------------|-------------------|-----------------|
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| < 2.x.x        | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool which set some terraform variables in the environment needed by this module.
 
More details about variables set by the terraform-wrapper available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

Here's 2 examples combined with the `function-app-with-plan` feature in order to have 2 functions on a dedicated App Service Plan.

### Windows
```hcl
module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  azure_region = module.azure-region.location
  client_name  = var.client_name
  environment  = var.environment
  stack        = var.stack
}

module "function-plan" {
  source  = "claranet/app-service-plan/azurerm"
  version = "x.x.x"

  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  function_app_name_prefix = "function1"

  app_service_plan_os = "Windows"

  app_service_plan_sku = {
    size = "S1"
    tier = "Standard"
  }

  function_app_application_settings = {
    "tracker_id"      = "AJKGDFJKHFDS"
    "backend_api_url" = "https://backend.domain.tld/api"
  }
}

module "function1" {
  source  = "azurerm/function-app-single/azurerm"
  version = "x.x.x"

  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  function_app_name_prefix = "function2"

  app_service_plan_id = module.function-plan.app_service_plan_id

  function_app_application_settings = {
    "tracker_id"      = "AJKGDFJKHFDS"
    "backend_api_url" = "https://backend.domain.tld/api"
  }
}
```

### Linux
```hcl
module "azure-region" {
  source  = "claranet/regions/azurem"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source = "claranet/rg/azurerm"
  version = "x.x.x"

  azure_region = module.azure-region.location
  client_name  = var.client_name
  environment  = var.environment

  stack        = var.stack
}

module "function-plan" {
  source  = "claranet/app-service-plan/azurerm"
  version = "x.x.x"

  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  function_app_name_prefix = "function1"

  app_service_plan_os         = "Linux"
  function_language_for_linux = "python"
  
  app_service_plan_sku = {
    size = "S1"
    tier = "Standard"
  }

  function_app_application_settings = {
    "tracker_id"      = "AJKGDFJKHFDS"
    "backend_api_url" = "https://backend.domain.tld/api"
  }
}

module "function1" {
  source = "claranet/function-app-single/azurerm"

  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  function_app_name_suffix = "function2"

  function_language_for_linux = "python"

  app_service_plan_id = module.function-plan.app_service_plan_id


}

module "function-app" {
  source  = "claranet/function-app-single/azurerm"
  version = "x.x.x"

  location = module.azure-region.location
  location_short = module.azure-region.location_short
  client_name = var.client_name
  environment = var.environment
  stack = var.stack

  resource_group_name = module.rg.resource_group_name

  function_app_name_prefix = "armv2"
  storage_account_name = "MyStorageName"

  app_service_plan_id = module.function-plan.app_service_plan_id
  identity_type = "UserAssigned"
  identity_ids  = [azurerm_user_assigned_identity.myIdentity.id]

  function_app_application_settings = {
    "tracker_id"      = "AJKGDFJKHFDS"
    "backend_api_url" = "https://backend.domain.tld/api"
  }

resource "azurerm_user_assigned_identity" "myIdentity" {
  resource_group_name = module.rg.resource_group_name
  location            = module.azure-region.location
  
  name                = "MyManagedIdentity"
}

}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_service\_plan\_id | Id of the App Service Plan for Function App hosting | `string` | n/a | yes |
| application\_insights\_extra\_tags | Extra tags to add to Application Insights | `map(string)` | `{}` | no |
| application\_insights\_instrumentation\_key | Application Insights instrumentation key for function logs, generated if null | `string` | `null` | no |
| application\_insights\_name\_prefix | Application Insights name prefix | `string` | `""` | no |
| application\_insights\_type | Application Insights type if need to be generated | `string` | `"web"` | no |
| client\_name | n/a | `string` | n/a | yes |
| environment | n/a | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| function\_app\_application\_settings | Function App application settings | `map(string)` | `{}` | no |
| function\_app\_extra\_tags | Extra tags to add to Function App | `map(string)` | `{}` | no |
| function\_app\_name\_prefix | Function App name prefix | `string` | `""` | no |
| function\_app\_version | Version of function app to use | `number` | `2` | no |
| function\_language\_for\_linux | Language of the Function App on Linux hosting, can be "dotnet", "node" or "python" | `string` | `"dotnet"` | no |
| identity\_ids | UserAssigned Identities ID to add to Function App. Mandatory if type is UserAssigned | `list(string)` | `null` | no |
| identity\_type | Add an Identity (MSI) to the function app. Possible values are SystemAssigned or UserAssigned | `string` | `null` | no |
| location | Azure location for App Service Plan. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| name\_prefix | Name prefix for all resources generated name | `string` | `""` | no |
| resource\_group\_name | n/a | `string` | n/a | yes |
| stack | n/a | `string` | n/a | yes |
| storage\_account\_enable\_advanced\_threat\_protection | Boolean flag which controls if advanced threat protection is enabled, see [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal) for more information. | `bool` | `false` | no |
| storage\_account\_enable\_https\_traffic\_only | Boolean flag which controls if https traffic only is enabled. | `bool` | `true` | no |
| storage\_account\_extra\_tags | Extra tags to add to Storage Account | `map(string)` | `{}` | no |
| storage\_account\_kind | Storage Account Kind | `string` | `"StorageV2"` | no |
| storage\_account\_name | Name of the Storage account to attach to function | `string` | `null` | no |
| storage\_account\_name\_prefix | Storage Account name prefix | `string` | `""` | no |
| storage\_account\_primary\_access\_key | Primary access key the storage account to use. If null a new storage account is created | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| app\_service\_plan\_id | Id of the created App Service Plan |
| application\_insights\_app\_id | App id of the associated Application Insights, empty if instrumentation key is provided |
| application\_insights\_id | Id of the associated Application Insights, empty if instrumentation key is provided |
| application\_insights\_instrumentation\_key | Instrumentation key of the associated Application Insights |
| application\_insights\_name | Name of the associated Application Insights, empty if instrumentation key is provided |
| function\_app\_connection\_string | Connection string of the created Function App |
| function\_app\_id | Id of the created Function App |
| function\_app\_identity | Identity block output of the Function App |
| function\_app\_name | Name of the created Function App |
| function\_app\_outbound\_ip\_addresses | Outbound IP adresses of the created Function App |
| storage\_account\_id | Id of the associated Storage Account, empty if connection string provided |
| storage\_account\_name | Name of the associated Storage Account, empty if connection string provided |
| storage\_account\_primary\_access\_key | Primary connection string of the associated Storage Account, empty if connection string provided |
| storage\_account\_primary\_connection\_string | Primary connection string of the associated Storage Account, empty if connection string provided |
| storage\_account\_secondary\_access\_key | Secondary connection string of the associated Storage Account, empty if connection string provided |
| storage\_account\_secondary\_connection\_string | Secondary connection string of the associated Storage Account, empty if connection string provided |

## Related documentation

Microsoft Azure Functions documentation: [github.com/Azure/Azure-Functions#documentation-1](https://github.com/Azure/Azure-Functions#documentation-1)

Microsoft Managed Identities documentation: [docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview)
