# Azure Function App V2

## Purpose
This Terraform feature creates an [Azure Function App V2](https://github.com/Azure/Azure-Functions/wiki/Azure-Functions-on-Linux-Preview).
A Storage Account and an Application Insights are required and are created if not provided.
An App Service Plan must be provided for hosting.

**This module requires the version 1.22+ of the AzureRM provider**

## Usage
Here's an example combined with the `function-app-with-plan` feature in order to have 2 functions on a dedicated App Service Plan.
```
module "az-region" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/regions.git?ref=vX.X.X"

  azure_region = "${var.azure_region}"
}

module "rg" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/rg.git?ref=vX.X.X"

  azure_region = "${module.az-region.location}"
  client_name  = "${var.client_name}"
  environment  = "${var.environment}"
  stack        = "${var.stack}"
}

module "function1" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/features/function-app-with-plan.git?ref=vX.X.X"

  location       = "${module.region.location}"
  location_short = "${module.region.location-short}"
  client_name    = "${var.client_name}"
  environment    = "${var.environment}"
  stack          = "${var.stack}"

  function_app_name_suffix = "-function1"

  function_language   = "python"
  resource_group_name = "${module.rg.resource_group_name}"

  app_service_plan_sku = {
    size = "S1"
    tier = "Standard"
  }

  function_app_application_settings = {
    "app_setting1" = "value1"
  }
}

module "function2" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/features/function-app-single.git?ref=vX.X.X"

  location       = "${module.region.location}"
  location_short = "${module.region.location-short}"
  client_name    = "${var.client_name}"
  environment    = "${var.environment}"
  stack          = "${var.stack}"

  resource_group_name = "${module.rg.resource_group_name}"

  function_app_name_suffix = "-function2"

  function_language   = "python"

  app_service_plan_id = "${module.function1.app_service_plan_id}"

  create_storage_account_resource   = "false"
  storage_account_connection_string = "${module.function1.storage_account_primary_connection_string}"

  create_application_insights_resource     = "false"
  application_insights_instrumentation_key = "${module.function1.application_insights_instrumentation_key}"

  function_app_application_settings = {
    "app_setting2" = "value2"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app\_service\_plan\_id | Id of the App Service Plan for Function App hosting | string | n/a | yes |
| app\_service\_plan\_name\_prefix | App Service Plan name prefix | string | `""` | no |
| application\_insights\_extra\_tags | Extra tags to add to Application Insights | map | `<map>` | no |
| application\_insights\_instrumentation\_key | Application Insights instrumentation key for function logs, generated if empty | string | `""` | no |
| application\_insights\_name\_prefix | Application Insights name prefix | string | `""` | no |
| application\_insights\_type | Application Insights type if need to be generated | string | `"Web"` | no |
| client\_name |  | string | n/a | yes |
| create\_application\_insights\_resource | Flag indicating if Application Insights resource should be automatically created (needed until Terraform 0.12), otherwise, variable `application_insights_instrumentation_key` must be set. Default to `true` | string | `"true"` | no |
| create\_storage\_account\_resource | Flag indicating if Storage Account resource should be automatically created (needed until Terraform 0.12), otherwise, variable `storage_account_connection_string` must be set. Default to `true` | string | `"true"` | no |
| environment |  | string | n/a | yes |
| extra\_tags | Extra tags to add | map | `<map>` | no |
| function\_app\_application\_settings | Function App application settings | map | `<map>` | no |
| function\_app\_extra\_tags | Extra tags to add to Function App | map | `<map>` | no |
| function\_app\_name\_prefix | Function App name prefix | string | `""` | no |
| function\_language | Language of the function, can be "dotnet", "node" or "python" | string | n/a | yes |
| location | Azure location for App Service Plan. | string | n/a | yes |
| location\_short | Short string for Azure location. | string | n/a | yes |
| name\_prefix | Name prefix for all resources generated name | string | `""` | no |
| resource\_group\_name |  | string | n/a | yes |
| stack |  | string | n/a | yes |
| storage\_account\_connection\_string | Storage Account connection string for Function App associated storage, a Storage Account is created if empty | string | `""` | no |
| storage\_account\_extra\_tags | Extra tags to add to Storage Account | map | `<map>` | no |
| storage\_account\_name\_prefix | Storage Account name prefix | string | `""` | no |

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
| function\_app\_name | Name of the created Function App |
| function\_app\_outbound\_ip\_addresses | Outbound IP adresses of the created Function App |
| storage\_account\_id | Id of the associated Storage Account, empty if connection string provided |
| storage\_account\_name | Name of the associated Storage Account, empty if connection string provided |
| storage\_account\_primary\_access\_key | Primary connection string of the associated Storage Account, empty if connection string provided |
| storage\_account\_primary\_connection\_string | Primary connection string of the associated Storage Account, empty if connection string provided |
| storage\_account\_secondary\_access\_key | Secondary connection string of the associated Storage Account, empty if connection string provided |
| storage\_account\_secondary\_connection\_string | Secondary connection string of the associated Storage Account, empty if connection string provided |

## Related documentation
Microsoft Azure Functions documentation: [https://github.com/Azure/Azure-Functions#documentation-1]
