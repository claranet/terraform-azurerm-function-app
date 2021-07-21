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
