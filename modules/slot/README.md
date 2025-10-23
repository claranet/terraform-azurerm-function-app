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
## Usage

```hcl
module "function_app_slot" {
  source = "./modules/slot"

  # Required variables
  name             = "staging"
  slot_os_type     = "linux"
  function_app_id  = azurerm_linux_function_app.main.id
  environment      = "dev"
  stack            = "myapp"

  # Storage configuration
  storage_account_name       = "mystorageaccount"
  storage_account_access_key = "storage_key"

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

  # Network configuration
  public_network_access_enabled = false
  vnet_integration_subnet_id     = "/subscriptions/.../subnets/subnet1"

  # Tags
  extra_tags = {
    Purpose = "staging"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3 |
| azurerm | ~> 4.36 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 4.36 |

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_function_app_slot.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot) | resource |
| [azurerm_windows_function_app_slot.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app_slot) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Project environment | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| name | Azure Function App slot name | `string` | n/a | yes |
| slot_os_type | The O/S type for the Function App slot. Possible values include `Windows`, `Linux`, and `Container` | `string` | n/a | yes |
| function_app_id | The ID of the Function App to create the slot for | `string` | n/a | yes |
| storage_account_name | The backend storage account name which will be used by this Function App slot | `string` | n/a | yes |
| storage_account_access_key | The access key which will be used to access the backend storage account for the Function App slot | `string` | `null` | no |
| storage_uses_managed_identity | Should the Function App slot use Managed Identity to access the storage account | `bool` | `false` | no |
| functions_extension_version | The runtime version associated with the Function App slot | `string` | `"~4"` | no |
| site_config | Site config for Function App slot | `any` | `{}` | no |
| app_settings | Application settings for Function App slot | `map(string)` | `{}` | no |
| connection_strings | Connection strings for Function App slot | `list(map(string))` | `[]` | no |
| auth_settings_v2 | Authentication settings V2 | `any` | `{}` | no |
| auth_settings_v2_login | Values for the authentication settings V2 login block | `any` | `{}` | no |
| https_only | HTTPS restriction for Function App slot | `bool` | `false` | no |
| builtin_logging_enabled | Should built in logging be enabled | `bool` | `true` | no |
| client_certificate_enabled | Should the Function App slot use Client Certificates | `bool` | `null` | no |
| client_certificate_mode | The mode of the Function App slot's client certificates requirement for incoming requests | `string` | `null` | no |
| identity | Map with identity block information | `object({type = string, identity_ids = list(string)})` | `{type = "SystemAssigned", identity_ids = []}` | no |
| key_vault_reference_identity_id | The User Assigned Identity ID to use for the Key Vault secrets reference | `string` | `null` | no |
| mount_points | Storage Account mount points | `list(object({...}))` | `[]` | no |
| sticky_settings | Lists of connection strings and app settings to prevent from swapping between slots | `object({...})` | `null` | no |
| public_network_access_enabled | Whether the Azure Function App slot is available from public network | `bool` | `false` | no |
| vnet_integration_subnet_id | ID of the subnet to associate with the Function App slot | `string` | `null` | no |
| ip_restriction | IP restriction for Function App slot | `any` | `{}` | no |
| scm_ip_restriction | SCM IP restriction for Function App slot | `any` | `{}` | no |
| scm_allowed_cidrs | SCM IPs restriction for Function App slot | `list(string)` | `[]` | no |
| scm_allowed_subnet_ids | SCM subnets restriction for Function App slot | `list(string)` | `[]` | no |
| default_tags_enabled | Option to enable or disable default tags | `bool` | `true` | no |
| extra_tags | Additional tags to add on resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| slot | Azure Function App slot output object |
| id | Azure Function App slot ID |
| name | Azure Function App slot name |
| default_hostname | Default hostname of the Function App slot |
| identity_principal_id | Azure Function App slot system identity principal ID |
| outbound_ip_addresses | Outbound IP addresses of the Function App slot |
| possible_outbound_ip_addresses | All possible outbound IP addresses of the Function App slot |
<!-- END_TF_DOCS -->
