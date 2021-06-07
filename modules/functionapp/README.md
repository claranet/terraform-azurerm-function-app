# Azure Function App

This Terraform submodule creates an [Azure Function App](https://docs.microsoft.com/en-us/azure/azure-functions/).
A [Storage Account](https://docs.microsoft.com/en-us/azure/storage/) and an [Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) 
are required and are created if not provided. An [App Service Plan](https://docs.microsoft.com/en-us/azure/app-service/overview-hosting-plans)
must be provided for hosting. This module also support Diagnostics Settings activation.

## Version compatibility

| Module version | Terraform version | AzureRM version |
|----------------|-------------------|-----------------|
| >= 4.x.x       | 0.13.x            | >= 2.42         |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| < 2.x.x        | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool which set some terraform variables in the environment needed by this module.
 
More details about variables set by the terraform-wrapper available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

Here are 2 examples combined with the `function-app-with-plan` feature in order to have 2 functions on a dedicated App Service Plan.

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

  kind = "Windows"

  sku = {
    size = "S1"
    tier = "Standard"
  }

}

module "function1" {
  source  = "claranet/function-app/azurerm//modules/functionapp"
  version = "x.x.x"

  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  function_app_name_prefix = "function1"

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

  kind = "Linux"
  
  sku = {
    size = "S1"
    tier = "Standard"
  }
}

module "function1" {
  source  = "claranet/function-app/azurerm//modules/functionapp"
  version = "x.x.x"

  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  function_app_name_prefix = "function1"

  function_language_for_linux = "python"

  app_service_plan_id = module.function-plan.app_service_plan_id
}

module "function2" {
  source  = "claranet/function-app/azurerm//modules/functionapp"
  version = "x.x.x"

  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  function_app_name_prefix = "armv2"
  storage_account_name     = "MyStorageName"

  app_service_plan_id = module.function-plan.app_service_plan_id
  identity_type       = "UserAssigned"
  identity_ids        = [azurerm_user_assigned_identity.myIdentity.id]

  function_app_application_settings = {
    "tracker_id"      = "AJKGDFJKHFDS"
    "backend_api_url" = "https://backend.domain.tld/api"
  }
  
  logs_destinations_ids = [
    data.terraform_remote_state.run.outputs.logs_storage_account_id,
    data.terraform_remote_state.run.outputs.log_analytics_workspace_id
  ]
}

resource "azurerm_user_assigned_identity" "myIdentity" {
  resource_group_name = module.rg.resource_group_name
  location            = module.azure-region.location
  
  name = "MyManagedIdentity"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_service\_plan\_id | Id of the App Service Plan for Function App hosting | `string` | n/a | yes |
| application\_insights\_custom\_name | Custom name for application insights deployed with function app | `string` | `""` | no |
| application\_insights\_enabled | Enable or disable the Application Insights deployment | `bool` | `true` | no |
| application\_insights\_extra\_tags | Extra tags to add to Application Insights | `map(string)` | `{}` | no |
| application\_insights\_id | ID of the existing Application Insights to use instead of deploying a new one. | `string` | `null` | no |
| application\_insights\_name\_prefix | Application Insights name prefix | `string` | `""` | no |
| application\_insights\_type | Application Insights type if need to be generated | `string` | `"web"` | no |
| application\_zip\_package\_path | Local or remote path of a zip package to deploy on the Function App | `string` | `null` | no |
| authorized\_ips | IPs restriction for Function. See documentation https://www.terraform.io/docs/providers/azurerm/r/function_app.html#ip_restriction | `list(string)` | `[]` | no |
| authorized\_service\_tags | Service Tags restriction for Function. See documentation https://www.terraform.io/docs/providers/azurerm/r/function_app.html#ip_restriction | `list(string)` | `[]` | no |
| authorized\_subnet\_ids | Subnets restriction for Function. See documentation https://www.terraform.io/docs/providers/azurerm/r/function_app.html#ip_restriction | `list(string)` | `[]` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| function\_app\_application\_settings | Function App application settings | `map(string)` | `{}` | no |
| function\_app\_custom\_name | Custom name for function app | `string` | `""` | no |
| function\_app\_extra\_tags | Extra tags to add to Function App | `map(string)` | `{}` | no |
| function\_app\_name\_prefix | Function App name prefix | `string` | `""` | no |
| function\_app\_version | Version of the function app runtime to use (Allowed values 2 or 3) | `number` | `3` | no |
| function\_language\_for\_linux | Language of the Function App on Linux hosting, can be "dotnet", "node" or "python" | `string` | `"dotnet"` | no |
| https\_only | Disable http procotol and keep only https | `bool` | `true` | no |
| identity\_ids | UserAssigned Identities ID to add to Function App. Mandatory if type is UserAssigned | `list(string)` | `null` | no |
| identity\_type | Add an Identity (MSI) to the function app. Possible values are SystemAssigned or UserAssigned | `string` | `"SystemAssigned"` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account | `number` | `30` | no |
| name\_prefix | Name prefix for all resources generated name | `string` | `""` | no |
| os\_type | A string indicating the Operating System type for this function app. | `string` | `null` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| site\_config | Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is not managed in this block. | `any` | `{}` | no |
| stack | Project stack name | `string` | n/a | yes |
| storage\_account\_access\_key | Access key the storage account to use. If null a new storage account is created | `string` | `null` | no |
| storage\_account\_enable\_advanced\_threat\_protection | Boolean flag which controls if advanced threat protection is enabled, see [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal) for more information. | `bool` | `false` | no |
| storage\_account\_enable\_https\_traffic\_only | Boolean flag which controls if https traffic only is enabled. | `bool` | `true` | no |
| storage\_account\_extra\_tags | Extra tags to add to Storage Account | `map(string)` | `{}` | no |
| storage\_account\_kind | Storage Account Kind | `string` | `"StorageV2"` | no |
| storage\_account\_min\_tls\_version | Storage Account minimal TLS version | `string` | `"TLS1_2"` | no |
| storage\_account\_name | Name of the Storage account to attach to function | `string` | `null` | no |
| storage\_account\_name\_prefix | Storage Account name prefix | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| app\_insights\_application\_type | Application Type of the associated Application Insights |
| app\_service\_plan\_id | Id of the created App Service Plan |
| application\_insights\_app\_id | App id of the associated Application Insights |
| application\_insights\_id | Id of the associated Application Insights |
| application\_insights\_instrumentation\_key | Instrumentation key of the associated Application Insights |
| application\_insights\_name | Name of the associated Application Insights |
| function\_app\_connection\_string | Connection string of the created Function App |
| function\_app\_id | Id of the created Function App |
| function\_app\_identity | Identity block output of the Function App |
| function\_app\_name | Name of the created Function App |
| function\_app\_outbound\_ip\_addresses | Outbound IP adresses of the created Function App |
| function\_app\_possible\_outbound\_ip\_addresses | All possible outbound IP adresses of the created Function App |
| storage\_account\_id | Id of the associated Storage Account, empty if connection string provided |
| storage\_account\_name | Name of the associated Storage Account, empty if connection string provided |
| storage\_account\_primary\_access\_key | Primary connection string of the associated Storage Account, empty if connection string provided |
| storage\_account\_primary\_connection\_string | Primary connection string of the associated Storage Account, empty if connection string provided |
| storage\_account\_secondary\_access\_key | Secondary connection string of the associated Storage Account, empty if connection string provided |
| storage\_account\_secondary\_connection\_string | Secondary connection string of the associated Storage Account, empty if connection string provided |

## Related documentation

  * Microsoft Azure Functions documentation: [github.com/Azure/Azure-Functions#documentation-1](https://github.com/Azure/Azure-Functions#documentation-1)
  * Microsoft Managed Identities documentation: [docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview)
  * Microsoft Azure Diagnostics Settings documentation [docs.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings)
