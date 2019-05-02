# Azure Function App with plan

This Terraform feature creates an [Azure Function App](https://docs.microsoft.com/en-us/azure/azure-functions/)
with its [App Service Plan](https://docs.microsoft.com/en-us/azure/app-service/overview-hosting-plans), 
a consumption plan by default.
A [Storage Account](https://docs.microsoft.com/en-us/azure/storage/) and an [Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) 
are required and are created if not provided.

## Requirements and limitations
 * Azure provider >= 1.22
 * Only [V2 runtime](https://docs.microsoft.com/en-us/azure/azure-functions/functions-versions) is supported

## Usage
You can use this module by including it this way:

### Windows
```hcl
module "az-region" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/regions.git?ref=vX.X.X"

  azure_region = "${var.azure_region}"
}

module "rg" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/rg.git?ref=vX.X.X"

  location     = "${module.az-region.location}"
  client_name  = "${var.client_name}"
  environment  = "${var.environment}"
  stack        = "${var.stack}"
}

module "function_app" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/features/function-app-with-plan.git?ref=vX.X.X"

  client_name         = "${var.client_name}"
  environment         = "${var.environment}"
  stack               = "${var.stack}"
  resource_group_name = "${module.rg.resource_group_name}"
  location            = "${module.az-region.location}"
  location_short      = "${module.az-region.location-short}"

  name_prefix       = "hello"
  
  app_service_plan_os = "Windows"

  function_app_application_settings = {
    setting_name = "setting_value"
  }

  extra_tags = {
    foo = "bar"
  }
}
```

### Linux
```hcl
module "az-region" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/regions.git?ref=vX.X.X"

  azure_region = "${var.azure_region}"
}

module "rg" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/rg.git?ref=vX.X.X"

  location     = "${module.az-region.location}"
  client_name  = "${var.client_name}"
  environment  = "${var.environment}"
  stack        = "${var.stack}"
}

module "function_app" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/features/function-app-with-plan.git?ref=vX.X.X"

  client_name         = "${var.client_name}"
  environment         = "${var.environment}"
  stack               = "${var.stack}"
  resource_group_name = "${module.rg.resource_group_name}"
  location            = "${module.az-region.location}"
  location_short      = "${module.az-region.location-short}"

  name_prefix       = "hello"
  
  app_service_plan_os         = "Linux"
  function_language_for_linux = "python"

  function_app_application_settings = {
    setting_name = "setting_value"
  }

  extra_tags = {
    foo = "bar"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app\_service\_plan\_extra\_tags | Extra tags to add to App Service Plan | map | `<map>` | no |
| app\_service\_plan\_name\_prefix | App Service Plan name prefix | string | `""` | no |
| app\_service\_plan\_os | App Service Plan OS for dedicated plans, can be "Linux" or "Windows" | string | n/a | yes |
| app\_service\_plan\_reserved | Flag indicating if dedicated App Service Plan should be reserved | string | `"false"` | no |
| app\_service\_plan\_sku | App Service Plan sku if created, consumption plan by default | map | `<map>` | no |
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
| function\_language\_for\_linux | Language of the Function App on Linux hosting, can be "dotnet", "node" or "python" | string | `"dotnet"` | no |
| location | Azure location for Function App and related resources | string | n/a | yes |
| location\_short | Short string for Azure location | string | n/a | yes |
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
| app\_service\_plan\_name | Name of the created App Service Plan |
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
