# Azure Function App Slot Submodule

This submodule creates Azure Function App slots for both Linux and Windows Function Apps.

## Features

- Support for both Linux and Windows Function App slots
- Configurable site configuration
- Network integration and IP restrictions
- Authentication settings v2
- Storage account mount points
- Identity management
- Sticky settings for slot swapping

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | OpenTofu version | AzureRM version |
| -------------- | ----------------- | ---------------- | --------------- |
| >= 8.x.x       | **Unverified**    | 1.8.x            | >= 4.0          |
| >= 7.x.x       | 1.3.x             |                  | >= 3.0          |
| >= 6.x.x       | 1.x               |                  | >= 3.0          |
| >= 5.x.x       | 0.15.x            |                  | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   |                  | >= 2.0          |
| >= 3.x.x       | 0.12.x            |                  | >= 2.0          |
| >= 2.x.x       | 0.12.x            |                  | < 2.0           |
| <  2.x.x       | 0.11.x            |                  | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](../../CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

```hcl
### Linux
module "function_app_linux" {
  source  = "claranet/function-app/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  name_prefix = "hello"

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

  application_insights_log_analytics_workspace_id = module.logs.id

  storage_account_identity_type = "SystemAssigned"

  logs_destinations_ids = [
    module.logs.id,
    module.logs.storage_account_id,
  ]

  extra_tags = {
    foo = "bar"
  }
}

module "function_app_slot" {
  source  = "claranet/function-app/azurerm//modules/slot"
  version = "x.x.x"

  # Required variables
  name            = "staging"
  slot_os_type    = "Linux"
  function_app_id = module.function_app_linux.id

  environment = var.environment
  stack       = var.stack

  # Storage configuration
  storage_account_name          = module.function_app_linux.storage_account_name
  storage_account_access_key    = !var.storage_uses_managed_identity ? module.function_app_linux.storage_account_primary_access_key : null
  storage_uses_managed_identity = var.storage_uses_managed_identity

  # Optional configuration
  site_config = {
    always_on = true
    application_stack = {
      dotnet_version = "6.0"
    }
  }

  app_settings = {
    "ENVIRONMENT" = "staging"
  }

  # Tags
  extra_tags = {
    Purpose = "staging"
  }
}
```

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 4.35 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_function_app_slot.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot) | resource |
| [azurerm_windows_function_app_slot.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app_slot) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_settings | Application settings for Function App slot. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#app_settings). | `map(string)` | `{}` | no |
| auth\_settings\_v2 | Authentication settings V2. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#auth_settings_v2). | `any` | `{}` | no |
| auth\_settings\_v2\_login | Values for the authentication settings V2 login block. | `any` | `{}` | no |
| builtin\_logging\_enabled | Should built in logging be enabled. Configures `AzureWebJobsDashboard` app setting based on the configured storage setting. | `bool` | `true` | no |
| client\_certificate\_enabled | Should the Function App slot use Client Certificates. | `bool` | `null` | no |
| client\_certificate\_mode | The mode of the Function App slot's client certificates requirement for incoming requests. Possible values are `Required`, `Optional`, and `OptionalInteractiveUser`. | `string` | `null` | no |
| connection\_strings | Connection strings for Function App slot. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#connection_string). | `list(map(string))` | `[]` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Additional tags to add on resources. | `map(string)` | `{}` | no |
| function\_app\_id | The ID of the Function App to create the slot for. | `string` | n/a | yes |
| functions\_extension\_version | The runtime version associated with the Function App slot. | `string` | `"~4"` | no |
| https\_only | HTTPS restriction for Function App slot. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#https_only). | `bool` | `false` | no |
| identity | Map with identity block information. | <pre>object({<br/>    type         = string<br/>    identity_ids = list(string)<br/>  })</pre> | <pre>{<br/>  "identity_ids": [],<br/>  "type": "SystemAssigned"<br/>}</pre> | no |
| ip\_restriction | IP restriction for Function App slot. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#ip_restriction). | `any` | `{}` | no |
| key\_vault\_reference\_identity\_id | The User Assigned Identity ID to use for the Key Vault secrets reference. If not set, the system assigned identity of the Function App slot will be used. | `string` | `null` | no |
| mount\_points | Storage Account mount points. Name is generated if not set and default type is `AzureFiles`. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#storage_account). | <pre>list(object({<br/>    name         = optional(string)<br/>    type         = optional(string, "AzureFiles")<br/>    account_name = string<br/>    share_name   = string<br/>    access_key   = string<br/>    mount_path   = optional(string)<br/>  }))</pre> | `[]` | no |
| name | Azure Function App slot name. | `string` | n/a | yes |
| public\_network\_access\_enabled | Whether the Azure Function App slot is available from public network. | `bool` | `false` | no |
| scm\_allowed\_cidrs | SCM IPs restriction for Function App slot. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#scm_ip_restriction). | `list(string)` | `[]` | no |
| scm\_allowed\_subnet\_ids | SCM subnets restriction for Function App slot. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#scm_ip_restriction). | `list(string)` | `[]` | no |
| scm\_ip\_restriction | SCM IP restriction for Function App slot. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#scm_ip_restriction). | `any` | `{}` | no |
| site\_config | Site config for Function App slot. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#site_config). IP restriction attribute is no more managed in this block. | `any` | `{}` | no |
| slot\_os\_type | The O/S type for the Function App slot. Possible values include `Windows`, `Linux`, `Container`, and `Flex` (when supported). | `string` | n/a | yes |
| stack | Project stack name. | `string` | n/a | yes |
| storage\_account\_access\_key | The access key which will be used to access the backend storage account for the Function App slot. | `string` | `null` | no |
| storage\_account\_name | The backend storage account name which will be used by this Function App slot. | `string` | n/a | yes |
| storage\_uses\_managed\_identity | Should the Function App slot use Managed Identity to access the storage account. | `bool` | `false` | no |
| vnet\_integration\_subnet\_id | ID of the subnet to associate with the Function App slot. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| default\_hostname | Default hostname of the Function App slot. |
| id | Azure Function App slot ID. |
| identity\_principal\_id | Azure Function App slot system identity principal ID. |
| name | Azure Function App slot name. |
| outbound\_ip\_addresses | Outbound IP addresses of the Function App slot. |
| possible\_outbound\_ip\_addresses | All possible outbound IP addresses of the Function App slot. |
| resource | Azure Function App slot resource object. |
<!-- END_TF_DOCS -->
