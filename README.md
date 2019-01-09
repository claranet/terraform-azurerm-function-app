# Azure Function App V2

## Purpose
This Terraform feature creates an [Azure Function App V2](https://github.com/Azure/Azure-Functions/wiki/Azure-Functions-on-Linux-Preview).
A Storage Account and an Application Insights are required and are created if not provided.
An App Service Plan must be provided for hosting.

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
| app_service_plan_id | Id of the App Service Plan for Function App hosting | string | - | yes |
| app_service_plan_name_suffix | App Service Plan name suffix | string | `` | no |
| application_insights_extra_tags | Extra tags to add to Application Insights | map | `<map>` | no |
| application_insights_instrumentation_key | Application Insights instrumentation key for function logs, generated if empty | string | `` | no |
| application_insights_name_suffix | Application Insights name suffix | string | `` | no |
| application_insights_type | Application Insights type if need to be generated | string | `Web` | no |
| client_name |  | string | - | yes |
| create_application_insights_resource | Flag indicating if Application Insights resource should be automatically created (needed until Terraform 0.12), otherwise, variable `application_insights_instrumentation_key` must be set. Default to `true` | string | `true` | no |
| create_storage_account_resource | Flag indicating if Storage Account resource should be automatically created (needed until Terraform 0.12), otherwise, variable `storage_account_connection_string` must be set. Default to `true` | string | `true` | no |
| environment |  | string | - | yes |
| extra_tags | Extra tags to add | map | `<map>` | no |
| function_app_application_settings | Function App application settings | map | `<map>` | no |
| function_app_extra_tags | Extra tags to add to Function App | map | `<map>` | no |
| function_app_name_suffix | Function App name suffix | string | `` | no |
| function_language | Language of the function, can be "dotnet", "node" or "python" | string | - | yes |
| location | Azure location for App Service Plan. | string | - | yes |
| location_short | Short string for Azure location. | string | - | yes |
| name_suffix | Name suffix for all resources generated name | string | `` | no |
| resource_group_name |  | string | - | yes |
| stack |  | string | - | yes |
| storage_account_connection_string | Storage Account connection string for Function App associated storage, a Storage Account is created if empty | string | `` | no |
| storage_account_extra_tags | Extra tags to add to Storage Account | map | `<map>` | no |
| storage_account_name_suffix | Storage Account name suffix | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| app_service_plan_id | Id of the created App Service Plan |
| application_insights_app_id | App id of the associated Application Insights, empty if instrumentation key is provided |
| application_insights_id | Id of the associated Application Insights, empty if instrumentation key is provided |
| application_insights_instrumentation_key | Instrumentation key of the associated Application Insights |
| application_insights_name | Name of the associated Application Insights, empty if instrumentation key is provided |
| function_app_connection_string | Connection string of the created Function App |
| function_app_id | Id of the created Function App |
| function_app_name | Name of the created Function App |
| function_app_outbound_ip_addresses | Outbound IP adresses of the created Function App |
| storage_account_id | Id of the associated Storage Account, empty if connection string provided |
| storage_account_name | Name of the associated Storage Account, empty if connection string provided |
| storage_account_primary_access_key | Primary connection string of the associated Storage Account, empty if connection string provided |
| storage_account_primary_connection_string | Primary connection string of the associated Storage Account, empty if connection string provided |
| storage_account_secondary_access_key | Secondary connection string of the associated Storage Account, empty if connection string provided |
| storage_account_secondary_connection_string | Secondary connection string of the associated Storage Account, empty if connection string provided |

## Related documentation
Microsoft Azure Functions documentation: [https://github.com/Azure/Azure-Functions#documentation-1]
