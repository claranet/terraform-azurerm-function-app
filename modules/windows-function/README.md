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

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.1 |
| azurerm | ~> 3.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.application_insights](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.function_app](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.storage_account](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_advanced_threat_protection.threat_protection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/advanced_threat_protection) | resource |
| [azurerm_app_service_virtual_network_swift_connection.function_vnet_integration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_virtual_network_swift_connection) | resource |
| [azurerm_application_insights.app_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_function_app.function_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app) | resource |
| [azurerm_storage_account.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account_network_rules.storage_network_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules) | resource |
| [azurerm_storage_blob.package_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_container.package_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_application_insights.app_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_service_plan.plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/service_plan) | data source |
| [azurerm_storage_account.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_storage_account_sas.package_sas](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account_sas) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_service\_plan\_id | Id of the App Service Plan for Function App hosting | `string` | n/a | yes |
| application\_insights\_custom\_name | Custom name for application insights deployed with function app | `string` | `""` | no |
| application\_insights\_enabled | Enable or disable the Application Insights deployment | `bool` | `true` | no |
| application\_insights\_extra\_tags | Extra tags to add to Application Insights | `map(string)` | `{}` | no |
| application\_insights\_id | ID of the existing Application Insights to use instead of deploying a new one. | `string` | `null` | no |
| application\_insights\_log\_analytics\_workspace\_id | ID of the Log Analytics Workspace to be used with Application Insights | `string` | `null` | no |
| application\_insights\_name\_prefix | Application Insights name prefix | `string` | `""` | no |
| application\_insights\_sampling\_percentage | Percentage of data produced by the monitored application sampled for Application Insights telemetry | `number` | `null` | no |
| application\_insights\_type | Application Insights type if need to be generated | `string` | `"web"` | no |
| application\_zip\_package\_path | Local or remote path of a zip package to deploy on the Function App | `string` | `null` | no |
| authorized\_ips | IPs restriction for Function in CIDR format. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#ip_restriction | `list(string)` | `[]` | no |
| authorized\_service\_tags | Service Tags restriction for Function. See documentation https://www.terraform.io/docs/providers/azurerm/r/function_app.html#ip_restriction | `list(string)` | `[]` | no |
| authorized\_subnet\_ids | Subnets restriction for Function. See documentation https://www.terraform.io/docs/providers/azurerm/r/function_app.html#ip_restriction | `list(string)` | `[]` | no |
| builtin\_logging\_enabled | Should the built-in logging of this Function App be enabled? | `bool` | `true` | no |
| client\_cert\_mode | The mode of the Function App's client certificates requirement for incoming requests | `string` | `null` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| default\_tags\_enabled | Option to enable or disable default tags | `bool` | `true` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| function\_app\_application\_settings | Function App application settings | `map(string)` | `{}` | no |
| function\_app\_custom\_name | Custom name for function app | `string` | `""` | no |
| function\_app\_extra\_tags | Extra tags to add to Function App | `map(string)` | `{}` | no |
| function\_app\_name\_prefix | Function App name prefix | `string` | `""` | no |
| function\_app\_version | Version of the function app runtime to use (Allowed values 2 or 3) | `number` | `3` | no |
| function\_app\_vnet\_integration\_enabled | Enable VNET integration with the Function App. `function_app_vnet_integration_subnet_id` is mandatory if enabled | `bool` | `false` | no |
| function\_app\_vnet\_integration\_subnet\_id | ID of the subnet to associate with the Function App (VNet integration) | `string` | `null` | no |
| function\_language\_for\_linux | Language of the Function App on Linux hosting, can be "dotnet", "node" or "python" | `string` | `"dotnet"` | no |
| https\_only | Disable http procotol and keep only https | `bool` | `true` | no |
| identity\_ids | UserAssigned Identities ID to add to Function App. Mandatory if type is UserAssigned | `list(string)` | `null` | no |
| identity\_type | Add an Identity (MSI) to the function app. Possible values are SystemAssigned or UserAssigned | `string` | `"SystemAssigned"` | no |
| ip\_restriction\_headers | IPs restriction headers for Function. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#headers | `map(list(string))` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account | `number` | `30` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| os\_type | A string indicating the Operating System type for this function app. | `string` | `null` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| scm\_authorized\_ips | SCM IPs restriction for Function. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction | `list(string)` | `[]` | no |
| scm\_authorized\_service\_tags | SCM Service Tags restriction for Function. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction | `list(string)` | `[]` | no |
| scm\_authorized\_subnet\_ids | SCM subnets restriction for Function. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction | `list(string)` | `[]` | no |
| scm\_ip\_restriction\_headers | IPs restriction headers for Function. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction | `map(list(string))` | `null` | no |
| site\_config | Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is not managed in this block. | `any` | `{}` | no |
| stack | Project stack name | `string` | n/a | yes |
| storage\_account\_access\_key | Access key the storage account to use. If null a new storage account is created | `string` | `null` | no |
| storage\_account\_authorized\_ips | IPs restriction for Function storage account in CIDR format | `list(string)` | `[]` | no |
| storage\_account\_enable\_advanced\_threat\_protection | Boolean flag which controls if advanced threat protection is enabled, see [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal) for more information. | `bool` | `false` | no |
| storage\_account\_enable\_https\_traffic\_only | Boolean flag which controls if https traffic only is enabled. | `bool` | `true` | no |
| storage\_account\_extra\_tags | Extra tags to add to Storage Account | `map(string)` | `{}` | no |
| storage\_account\_identity\_ids | Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account | `list(string)` | `null` | no |
| storage\_account\_identity\_type | Specifies the type of Managed Service Identity that should be configured on this Storage Account | `string` | `null` | no |
| storage\_account\_kind | Storage Account Kind | `string` | `"StorageV2"` | no |
| storage\_account\_min\_tls\_version | Storage Account minimal TLS version | `string` | `"TLS1_2"` | no |
| storage\_account\_name | Name of the Storage account to attach to function | `string` | `null` | no |
| storage\_account\_name\_prefix | Storage Account name prefix | `string` | `""` | no |
| storage\_account\_network\_bypass | Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of `Logging`, `Metrics`, `AzureServices`, or `None`. | `list(string)` | <pre>[<br>  "Logging",<br>  "Metrics",<br>  "AzureServices"<br>]</pre> | no |
| storage\_account\_network\_rules\_enabled | Enable Storage account network default rules for functions | `bool` | `true` | no |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| app\_service\_plan\_id | Id of the created App Service Plan |
| application\_insights\_app\_id | App id of the associated Application Insights |
| application\_insights\_application\_type | Application Type of the associated Application Insights |
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
| storage\_account\_network\_rules | Network rules of the associated Storage Account |
| storage\_account\_primary\_access\_key | Primary connection string of the associated Storage Account, empty if connection string provided |
| storage\_account\_primary\_connection\_string | Primary connection string of the associated Storage Account, empty if connection string provided |
| storage\_account\_secondary\_access\_key | Secondary connection string of the associated Storage Account, empty if connection string provided |
| storage\_account\_secondary\_connection\_string | Secondary connection string of the associated Storage Account, empty if connection string provided |
<!-- END_TF_DOCS -->

## Related documentation

Microsoft Azure Functions documentation: [github.com/Azure/Azure-Functions#documentation-1](https://github.com/Azure/Azure-Functions#documentation-1)

Microsoft Managed Identities documentation: [docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview)

Microsoft Azure Diagnostics Settings documentation [docs.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings)
