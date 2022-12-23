# v7.2.1 - 2022-12-23

Fixed
  * AZ-963: Fix naming

# v7.2.0 - 2022-12-16

Added
  * AZ-931: Add staging slot option and default hostname outputs

Changed
  * AZ-908: Bump App Service Plan module to `v6.1.1`

# v7.1.1 - 2022-12-02

Fixed
  * AZ-907: Fix Storage Account firewall when no VNet integration

# v7.1.0 - 2022-11-25

Changed
  * AZ-908: Use the new data source for CAF naming (instead of resource)

Fixed
  * AZ-907: Fix Storage Account firewall for Consumption functions
  * AZ-907: Bump `storage-account` module and AzureRM provider to `v3.25+`

# v7.0.1 - 2022-10-28

Fixed
  * AZ-887: Rename and fix the ternary condition of the `function_out_ips` local variable 

# v7.0.0 - 2022-09-30

Breaking
  * AZ-840: Upgrade to Terraform 1.3+, bump inner modules
  * AZ-835: Remove `function_app_vnet_integration_enabled` variable
  * AZ-835: Remove `function_language_for_linux` variable, use `site_config.application_stack` instead

Changed
  * AZ-835: Code cleanup
  * AZ-835: `azurerm_app_service_virtual_network_swift_connection` resource replaced by the default `virtual_network_subnet_id` parameter
  * AZ-835: Minimal version of the Azurerm provider to `v3.22`

# v6.3.0 - 2022-08-19

Changed
  * AZ-130: Use our `storage-account` module instead of inline resources

# v6.2.2 - 2022-06-24

Fixed
  * AZ-772: Fix deprecated terraform code with `v1.2.3`

# v6.2.1 - 2022-06-23
 
Fixed
  * AZ-776: Fix outputs reference for linux-function and windows-function

# v6.2.0 - 2022-06-10

Breaking
  * AZ-717: Provider AzureRM v3 new provider `function` resources
  * AZ-717: Use new `service-plan` module (instead of `app-service-plan`)
  * AZ-717: The `azurerm_function_app` resource has been superseded by the `azurerm_linux_function_app` and `azurerm_windows_function_app` resources

# v6.1.0 - 2022-05-20

Changed
  * AZ-717: Revamp `function-app` outputs

Added
  * AZ-586: Add multiple options for Application Insights resource

# v6.0.1 - 2022-05-13

Fixed
  * AZ-588: Fix optional `function_app_vnet_integration_subnet_id` in storage account network rules

# v6.0.0 - 2022-05-10

Breaking
  * AZ-717: Provider AzureRM v3 minimal support

# v5.2.0 - 2022-05-06

Added
  * AZ-694: Minimum AzureRM version required 2.72
  * AZ-694: Add log analytics workspace parameter + site config parameter
  * AZ-694: Add additional function-app options (certificat requierement + built-in login)

Breaking
  * AZ-588: Storage account network rules

# v5.1.0 - 2022-02-11

Added
  * AZ-615: Add an option to enable or disable default tags

# v5.0.0 - 2022-01-13

Breaking
  * AZ-515: Option to use Azure CAF naming provider to name resources
  * AZ-515: Require Terraform 0.13+

# v4.2.0 - 2021-11-18

Changed
  * AZ-572: Revamp examples and improve CI
  * AZ-592: Bump minimum AzureRM provider version to `v2.57`

Added
  * AZ-588: VNet integration option
  * AZ-592: Support for the `site_config.ip_restrictions.headers` property
  * AZ-595: SCM parameters now uses dedicated variables, like in `app-service-web` module

Fixed
  * AZ-589: Avoid plan drift when specifying Diagnostic Settings categories

# v4.1.0 - 2021-09-07

Breaking
  * AZ-565: Add `client_name` to default storage account name

Fixed
  * AZ-530: Fix unused `https_only` variable

Changed
  * AZ-532: Revamp README with latest `terraform-docs` tool

# v4.0.1 - 2021-07-21

Fixed
  * AZ-534: Fix `is-local-zip` for default value of `application_zip_package_path` at `null`

# v4.0.0 - 2021-07-16

Added
  * AZ-488: Merge `function-app-with-plan`  `function-app-single` modules with the second as submodule.
  * AZ-486: Allow deploying ZIP packages

Changed
  * AZ-489: Reuse existing variable for `function_app_os_type`
  * AZ-160: Unify diagnostics settings on all Claranet modules
  * AZ-488: Refactor variables

Fixed
  * AZ-489: Fix submodule default value for `function_app_version`
  * AZ-489: Force user to define `storage_account_name` if `storage_account_primary_access_key` is set
  * AZ-489: Set setting `WEBSITES_ENABLE_APP_SERVICE_STORAGE` to false when using custom Docker image (Azure issue)
