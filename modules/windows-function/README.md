# Azure Function (Windows)

This Terraform submodule creates an [Azure Function (Windows)](https://docs.microsoft.com/en-us/azure/azure-functions/).
A [Storage Account](https://docs.microsoft.com/en-us/azure/storage/) and an [Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) 
are required and are created if not provided. A [Service Plan](https://docs.microsoft.com/en-us/azure/app-service/overview-hosting-plans)
must be provided for hosting. This module also support Diagnostics Settings activation.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool which set some terraform variables in the environment needed by this module.
 
More details about variables set by the terraform-wrapper available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

Here are 2 examples in order to have 2 functions on a dedicated Service Plan.

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

  service_plan_id = module.function-plan.service_plan_id

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

  service_plan_id = module.function-plan.service_plan_id
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

  service_plan_id = module.function-plan.service_plan_id
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
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | ~> 3.25 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | 6.2.0 |
| storage | claranet/storage-account/azurerm | 7.3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.app_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_storage_account_network_rules.storage_network_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_network_rules) | resource |
| [azurerm_storage_blob.package_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_container.package_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_windows_function_app.windows_function](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app) | resource |
| [azurerm_windows_function_app_slot.windows_function_slot](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app_slot) | resource |
| [azurecaf_name.application_insights](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.function_app](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.storage_account](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurerm_application_insights.app_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_service_plan.plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/service_plan) | data source |
| [azurerm_storage_account.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_storage_account_sas.package_sas](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account_sas) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application\_insights\_custom\_name | Custom name for application insights deployed with function app | `string` | `""` | no |
| application\_insights\_daily\_data\_cap | Daily data volume cap (in GB) for Application Insights | `number` | `null` | no |
| application\_insights\_daily\_data\_cap\_notifications\_disabled | Disable email notifications when data volume cap is met | `bool` | `null` | no |
| application\_insights\_enabled | Enable or disable the Application Insights deployment | `bool` | `true` | no |
| application\_insights\_extra\_tags | Extra tags to add to Application Insights | `map(string)` | `{}` | no |
| application\_insights\_force\_customer\_storage\_for\_profiler | Enable Application Insights component to force users to create their own storage account for profiling | `bool` | `false` | no |
| application\_insights\_id | ID of the existing Application Insights to use instead of deploying a new one. | `string` | `null` | no |
| application\_insights\_internet\_ingestion\_enabled | Enable ingestion support from Application Insights component over the Public Internet | `bool` | `true` | no |
| application\_insights\_internet\_query\_enabled | Enable querying support from Application Insights component over the Public Internet | `bool` | `true` | no |
| application\_insights\_ip\_masking\_disabled | Disable IP masking in logs | `bool` | `false` | no |
| application\_insights\_local\_authentication\_disabled | Disable Non-Azure AD based Auth | `bool` | `false` | no |
| application\_insights\_log\_analytics\_workspace\_id | ID of the Log Analytics Workspace to be used with Application Insights | `string` | `null` | no |
| application\_insights\_name\_prefix | Application Insights name prefix | `string` | `""` | no |
| application\_insights\_retention | Specify retention period (in days) for logs | `number` | `90` | no |
| application\_insights\_sampling\_percentage | Percentage of data produced by the monitored application sampled for Application Insights telemetry | `number` | `null` | no |
| application\_insights\_type | Application Insights type if need to be generated. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights#application_type | `string` | `"web"` | no |
| application\_zip\_package\_path | Local or remote path of a zip package to deploy on the Function App | `string` | `null` | no |
| authorized\_ips | IPs restriction for Function in CIDR format. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#ip_restriction | `list(string)` | `[]` | no |
| authorized\_service\_tags | Service Tags restriction for Function. See documentation https://www.terraform.io/docs/providers/azurerm/r/function_app.html#ip_restriction | `list(string)` | `[]` | no |
| authorized\_subnet\_ids | Subnets restriction for Function. See documentation https://www.terraform.io/docs/providers/azurerm/r/function_app.html#ip_restriction | `list(string)` | `[]` | no |
| builtin\_logging\_enabled | Should built in logging be enabled | `bool` | `true` | no |
| client\_certificate\_enabled | Should the function app use Client Certificates | `bool` | `null` | no |
| client\_certificate\_mode | (Optional) The mode of the Function App's client certificates requirement for incoming requests. Possible values are `Required`, `Optional`, and `OptionalInteractiveUser`. | `string` | `null` | no |
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
| function\_app\_vnet\_integration\_subnet\_id | ID of the subnet to associate with the Function App (VNet integration) | `string` | `null` | no |
| https\_only | Disable http procotol and keep only https | `bool` | `true` | no |
| identity\_ids | UserAssigned Identities ID to add to Function App. Mandatory if type is UserAssigned | `list(string)` | `null` | no |
| identity\_type | Add an Identity (MSI) to the function app. Possible values are SystemAssigned or UserAssigned | `string` | `"SystemAssigned"` | no |
| ip\_restriction\_headers | IPs restriction headers for Function. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#headers | `map(list(string))` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account. | `number` | `30` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| scm\_authorized\_ips | SCM IPs restriction for Function. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction | `list(string)` | `[]` | no |
| scm\_authorized\_service\_tags | SCM Service Tags restriction for Function. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction | `list(string)` | `[]` | no |
| scm\_authorized\_subnet\_ids | SCM subnets restriction for Function. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction | `list(string)` | `[]` | no |
| scm\_ip\_restriction\_headers | IPs restriction headers for Function. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction | `map(list(string))` | `null` | no |
| service\_plan\_id | Id of the App Service Plan for Function App hosting | `string` | n/a | yes |
| site\_config | Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is not managed in this block. | `any` | `{}` | no |
| stack | Project stack name | `string` | n/a | yes |
| staging\_slot\_custom\_application\_settings | Override staging slot with custom application settings. | `map(string)` | `null` | no |
| staging\_slot\_custom\_name | Custom name of the Function App slot | `string` | `null` | no |
| staging\_slot\_enabled | Create a staging slot alongside the Function App for blue/green deployment purposes. | `bool` | `false` | no |
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
| application\_insights\_app\_id | App ID of the associated Application Insights |
| application\_insights\_application\_type | Application Type of the associated Application Insights |
| application\_insights\_id | ID of the associated Application Insights |
| application\_insights\_instrumentation\_key | Instrumentation key of the associated Application Insights |
| application\_insights\_name | Name of the associated Application Insights |
| function\_app\_connection\_string | Connection string of the created Function App |
| function\_app\_default\_hostname | Default hostname of the created Function App |
| function\_app\_id | ID of the created Function App |
| function\_app\_identity | Identity block output of the Function App |
| function\_app\_name | Name of the created Function App |
| function\_app\_outbound\_ip\_addresses | Outbound IP adresses of the created Function App |
| function\_app\_possible\_outbound\_ip\_addresses | All possible outbound IP adresses of the created Function App |
| function\_app\_slot\_default\_hostname | Default hostname of the Function App slot |
| function\_app\_slot\_identity | Identity block output of the Function App slot |
| function\_app\_slot\_name | Name of the Function App slot |
| service\_plan\_id | Id of the created App Service Plan |
| storage\_account\_id | ID of the associated Storage Account, `null` if connection string provided |
| storage\_account\_name | Name of the associated Storage Account, `null` if connection string provided |
| storage\_account\_network\_rules | Network rules of the associated Storage Account |
| storage\_account\_primary\_access\_key | Primary connection string of the associated Storage Account, `null` if connection string provided |
| storage\_account\_primary\_connection\_string | Primary connection string of the associated Storage Account, `null` if connection string provided |
| storage\_account\_secondary\_access\_key | Secondary connection string of the associated Storage Account, `null` if connection string provided |
| storage\_account\_secondary\_connection\_string | Secondary connection string of the associated Storage Account, `null` if connection string provided |
<!-- END_TF_DOCS -->

## Related documentation

Microsoft Azure Functions documentation: [github.com/Azure/Azure-Functions#documentation-1](https://github.com/Azure/Azure-Functions#documentation-1)

Microsoft Managed Identities documentation: [docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview)

Microsoft Azure Diagnostics Settings documentation [docs.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings)
