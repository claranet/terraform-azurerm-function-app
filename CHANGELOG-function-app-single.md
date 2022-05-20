# v4.3.0 - 2021-04-26

Added
  * AZ-479: Added a variable to enable the choice a TLS version for the function storage account (Default version is set to TLS1_2)
  * AZ-479: Added output for all possibles IPs of the function app

# v4.2.1 - 2021-03-31

Fixed
  * AZ-465: Fix CORS block in `site_config`

# v4.2.0 - 2021-03-09

Added
 * AZ-424: Add Service Tags (AzureRM 2.42+)

# v3.2.0/v4.1.0 - 2021-01-19

Added
 * AZ-374: Allow disabling application insight deployment.
 * AZ-423: Use connection string for Application Insights integration

Changed
  * AZ-245: Assign a "SystemAssigned" identity by default

Fixed
  * AZ-420: Fix `linux_fx_version` not used with serverless functionapps

# v3.1.1/v4.0.1 - 2020-12-31

Fixed
  * AZ-415: Perpetual changes due to `WEBSITE_CONTENTSHARE` and `WEBSITE_CONTENTAZUREFILECONNECTIONSTRING` app settings.

# v3.1.0/v4.0.0 - 2020-12-30

Breaking
  * AZ-368: Force HTTPS
  
Added
  * AZ-347: Add `application_insight_custom_name` and `function_app_custom_name` variables
  * AZ-364: Add network rules parameters
  * AZ-366: Add diagnostics logs.

Fixed
  * AZ-349: Fix Docker images versions for v3 function apps
  
Changed
  * AZ-350: Upgrade Docker images from DockerHub to Official Microsoft Docker images repository
  * AZ-367: Adding `site_config` variable to adjust its values

# v3.0.0 - 2020-07-30

Breaking
  * AZ-198: Upgrade to AzureRM >= v2.0
 
Added
  * AZ-242: Allow to manage MSI on the app function
  
# v2.2.0 - 2020-07-30

Added
  * AZ-201: Allow to use function app v3
  
Breaking
  * AZ-238: Remove `create_storage_account_resource` and `create_application_insights_resource` variables. Now resources are created if `storage_account_connection_string` is `null` and `application_insights_instrumentation_key` is `null`. 
   
# v2.1.0 - 2020-02-17

Added
  * AZ-169: Storage Account - allow to configure account\_kind (default to StorageV2), enable\_https\_traffic\_only (default to false) and enable\_advanced\_threat\_protection (default to false)

# v2.0.1 - 2019-11-15

Fixed
  * AZ-118: Documentation update for public release

# v2.0.0 - 2019-11-14

Breaking
  * AZ-94: Upgrade module to terraform 0.12 / HCL2

# v1.1.0 - 2019-05-15

Added
  * AZ-78: Windows support

# v1.0.0 - 2019-04-23

Added
  * AZ-47: First release
