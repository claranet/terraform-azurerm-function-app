## 8.6.2 (2025-09-30)

### Code Refactoring

* **deps:** 🔗 update claranet/azurecaf to ~> 1.3.0 🔧 618a314

### Miscellaneous Chores

* **deps:** update dependency trivy to v0.67.0 3c0365d

## 8.6.1 (2025-09-26)

### Bug Fixes

* 🐛 update moved block for storage 046d083

## 8.6.0 (2025-09-19)

### Features

* **refactor:** ✨ ♻️ remove submodules, unified module 💥💥💥 501aed9

### Code Refactoring

* ♻️ add moved blocks 24e5ee7
* ♻️ global update 5ba709f
* ♻️ remove lookups ce91ac2
* ♻️ type site_config instead of any baf37ab

### Continuous Integration

* 👷 update CI default vars 5060af4

### Miscellaneous Chores

* 🗑️ rebase 2e27902
* 🗑️ remove submodules fbd5170
* **deps:** update dependency opentofu to v1.10.6 ae3fff5
* **deps:** update dependency tflint to v0.59.1 95d56d8
* **deps:** update dependency trivy to v0.66.0 60c6cf4
* **deps:** update terraform claranet/diagnostic-settings/azurerm to ~> 8.2.0 024a024
* merge branch 'AZ-1613_refactor' into 'refactor' 5aa4faa

## 8.5.0 (2025-08-29)

### Features

* **AZ-1605:** ✨ ignore hidden-links tags changes a87256c
* **GH-15:** ✨ add Flex Consumption Function submodule 539aa0a

### Bug Fixes

* **AZ-1606:** 🐛 fix external data source 08c247f
* **AZ-1606:** 🐛 fix storage account name not found 57ee6bf
* **AZ-1606:** 🐛 remove unnecessary `depends_on` that triggers resources recreation 87257d4

### Code Refactoring

* ♻️ handle flex 54c3b76
* **GH-15:** ♻️ add needed container storage for Flex mode 4133c3f
* **GH-15:** ♻️ update root module c386a0d

### Miscellaneous Chores

* 🔧 fix outputs 7b9650b
* apply suggestion df2b98a
* **deps:** 🔗 bump AzureRM provider version to v4.31+ 4efba37
* **deps:** 🔧 update azurerm provider version to ~> 4.35 9d936dc
* **deps:** update dependency claranet/diagnostic-settings/azurerm to ~> 8.1.0 1b01639
* **deps:** update pre-commit hook pre-commit/pre-commit-hooks to v6 c614add
* **deps:** update terraform claranet/app-service-plan/azurerm to ~> 8.2.0 c66b353
* **deps:** update tools 458946a
* tfdocs f3b5942

## 8.4.0 (2025-08-01)

### Features

* **GH-14:** ✨ add `mount_points` and `staging_slot_mount_points` variables 4ba3cc4

### Bug Fixes

* **GH-13:** 🐛 add missing `public_network_access_enabled` params 3f6d69f

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.10.3 365ab48
* **deps:** update dependency tflint to v0.58.1 5dcfc3b
* **deps:** update tools 97ffb26

## 8.3.0 (2025-07-04)

### Features

* **AZ-1579:** ✨ add storage logs variables af4be6f

### Miscellaneous Chores

* **⚙️:** ✏️ update template identifier for MR review 37427b5
* 🗑️ remove old commitlint configuration files da2797f
* **deps:** update dependency opentofu to v1.10.0 a20219c
* **deps:** update dependency opentofu to v1.10.1 c2def2d
* **deps:** update dependency tflint to v0.58.0 6a7c781
* **deps:** update dependency trivy to v0.63.0 973b8bf
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.2.1 0a1bbd4
* **deps:** update tools c4f5348

## 8.2.0 (2025-05-23)

### Features

* **GH-11:** add public_network_access_enabled variable 71ae741

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.9.1 be7eb38
* **deps:** update dependency terraform-docs to v0.20.0 b3481da
* **deps:** update dependency tflint to v0.57.0 87c0714
* **deps:** update dependency trivy to v0.61.1 298026f
* **deps:** update dependency trivy to v0.62.0 89bfadf
* **deps:** update dependency trivy to v0.62.1 7a69bbf
* **deps:** update terraform claranet/storage-account/azurerm to ~> 8.6.0 f1fbdfc

## 8.1.1 (2025-04-04)

### Bug Fixes

* add `storage_infrastructure_encryption_enabled` option 3b74fed

### Documentation

* update variable name 83d83f1

### Miscellaneous Chores

* **deps:** update dependency claranet/storage-account/azurerm to ~> 8.5.0 7b18488
* **deps:** update dependency pre-commit to v4.2.0 e941ddd
* **deps:** update dependency trivy to v0.60.0 23b3438
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.22.0 b7e7279
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.2.0 916a57a
* **deps:** update terraform claranet/storage-account/azurerm to ~> 8.4.0 c8081b1
* **deps:** update tools 7a469f2

## 8.1.0 (2025-02-28)

### Features

* **AZ-1528:** add firewall default action to site_config 0822f0c

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.6 c0a934c
* **deps:** update dependency opentofu to v1.8.8 21db39f
* **deps:** update dependency opentofu to v1.9.0 c9f329e
* **deps:** update dependency pre-commit to v4.1.0 fe0fbba
* **deps:** update dependency tflint to v0.55.0 5a73b41
* **deps:** update dependency trivy to v0.57.1 2b88740
* **deps:** update dependency trivy to v0.58.1 aeb71b0
* **deps:** update dependency trivy to v0.58.2 1415efd
* **deps:** update dependency trivy to v0.59.1 e7f3d43
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.19.0 f019e59
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.20.0 55cdb89
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.21.0 e5bb385
* **deps:** update terraform claranet/app-service-plan/azurerm to ~> 8.1.0 79236b4
* **deps:** update terraform claranet/storage-account/azurerm to ~> 8.3.0 a6bff6d
* **deps:** update tools 6db6919
* **deps:** update tools 7275af1
* update Github templates ef372a3
* update tflint config for v0.55.0 7ef8e65

## 8.0.0 (2024-11-15)

### ⚠ BREAKING CHANGES

* **AZ-1088:** AzureRM Provider v4+ and OpenTofu 1.8+

### Features

* **AZ-1088:** add Storage Account RBAC variable e0d25ac
* **AZ-1088:** module v8 structure and updates f1d17c5

### Code Refactoring

* **AZ-1088:** apply module structure suggestions 9513a62
* **AZ-1088:** variable name updates 5330eb7

### Miscellaneous Chores

* apply suggestion(s) to file(s) ef80c4f
* **deps:** update dependency claranet/app-service-plan/azurerm to v8 8f296ad
* **deps:** update dependency claranet/diagnostic-settings/azurerm to v8 e72563b
* **deps:** update dependency opentofu to v1.8.4 f54b1c4
* **deps:** update dependency pre-commit to v4.0.1 b4b4722
* **deps:** update dependency tflint to v0.54.0 4de7ea6
* **deps:** update dependency trivy to v0.56.2 569a0fa
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.1.0 d1d82c0
* **deps:** update terraform claranet/storage-account/azurerm to v8 27b2ab7
* **deps:** update tools 2556d58
* update examples structure 3b07b1f

## 7.13.1 (2024-10-08)

### Documentation

* update submodule READMEs with latest template 206da17

### Miscellaneous Chores

* **deps:** update dependency claranet/app-service-plan/azurerm to ~> 7.1.0 1a6207a
* **deps:** update dependency claranet/diagnostic-settings/azurerm to v7 a9e1809
* **deps:** update dependency claranet/storage-account/azurerm to ~> 7.14.0 76c1829
* **deps:** update dependency opentofu to v1.8.3 47cb9c5
* **deps:** update dependency pre-commit to v4 d921ca7
* **deps:** update dependency trivy to v0.56.0 f438f0f
* **deps:** update dependency trivy to v0.56.1 021b7b6
* **deps:** update pre-commit hook pre-commit/pre-commit-hooks to v5 68e0f4a
* prepare for new examples structure 96636ab

## 7.13.0 (2024-10-03)

### Features

* use Claranet "azurecaf" provider 4d0faa2

### Documentation

* update README badge to use OpenTofu registry 405b7a7
* update README with `terraform-docs` v0.19.0 499e6ce
* update submodule README with `terraform-docs` v0.19.0 6110b50

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.2 8bb9468
* **deps:** update dependency trivy to v0.55.0 2418f2d
* **deps:** update dependency trivy to v0.55.1 afaf6cd
* **deps:** update dependency trivy to v0.55.2 fcb3b93
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.18.0 e4df003
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.0 c19df6d
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.1 d8f20fb
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.2 5446852
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.3 5275645
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.95.0 679a55b
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.0 52659bf
* **deps:** update tools 0519289

## 7.12.1 (2024-08-29)

### Bug Fixes

* bump `storage-account` to latest version bcf3981

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.7.3 9b084f2
* **deps:** update dependency opentofu to v1.8.0 7251fe4
* **deps:** update dependency opentofu to v1.8.1 3cc0f59
* **deps:** update dependency pre-commit to v3.8.0 2d81abf
* **deps:** update dependency tflint to v0.51.2 0d52cfd
* **deps:** update dependency tflint to v0.52.0 2d7e48b
* **deps:** update dependency tflint to v0.53.0 4afef03
* **deps:** update dependency trivy to v0.53.0 c448b67
* **deps:** update dependency trivy to v0.54.1 960ce90
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.17.0 dcd3580
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.0 6bad414
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.1 ea82b32
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.2 dbded88
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.93.0 a93c911

## 7.12.0 (2024-06-14)


### Features

* upgrade `service-plan` module to `v7.0` e5b9ef6


### Bug Fixes

* storage module now require AzureRM provider `v3.102+` a210135


### Styles

* typo 2b40bbd


### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.7.1 d71b9cf
* **deps:** update dependency opentofu to v1.7.2 7c4e1ba
* **deps:** update dependency pre-commit to v3.7.1 581d631
* **deps:** update dependency terraform-docs to v0.18.0 6bf1e27
* **deps:** update dependency tflint to v0.51.1 76343ad
* **deps:** update dependency trivy to v0.51.2 a21656e
* **deps:** update dependency trivy to v0.51.4 43344d6
* **deps:** update dependency trivy to v0.52.0 5f271cd
* **deps:** update dependency trivy to v0.52.1 9872c0f
* **deps:** update dependency trivy to v0.52.2 aad4a50
* **deps:** update terraform claranet/storage-account/azurerm to ~> 7.13.0 643593a

## 7.11.0 (2024-05-07)


### Features

* add Authentication Settings V2 9fd91d7


### Miscellaneous Chores

* **deps:** update dependency claranet/app-service-plan/azurerm to ~> 6.5.0 9d3fe74
* **deps:** update dependency tflint to v0.51.0 8eca4e7
* **deps:** update dependency trivy to v0.51.0 9fe6146
* **deps:** update dependency trivy to v0.51.1 20ce53c
* **deps:** update terraform claranet/storage-account/azurerm to ~> 7.12.0 783e3a8

## 7.10.0 (2024-05-03)


### Features

* **AZ-1405:** add `zone_balancing_enabled` parameter to app service plan 376cc63


### Continuous Integration

* **AZ-1391:** update semantic-release config [skip ci] 16e0be0


### Miscellaneous Chores

* **deps:** enable automerge on renovate eb8ed9f
* **deps:** update dependency opentofu to v1.7.0 aa7d2fc
* **deps:** update dependency trivy to v0.50.2 2aaf0a7
* **deps:** update dependency trivy to v0.50.4 2a34ed4
* **pre-commit:** update commitlint hook 97e3aed
* **release:** remove legacy `VERSION` file 677a19f

## 7.9.0 (2024-04-19)


### Features

* **AZ-1362:** add log analytics precondition 7dec34d


### Continuous Integration

* **AZ-1391:** enable semantic-release [skip ci] 7b26f6b


### Miscellaneous Chores

* **deps:** add renovate.json e489349
* **deps:** update dependency claranet/storage-account/azurerm to ~> 7.11.0 c0d3a00
* **deps:** update renovate.json 8c34526
* **deps:** update terraform claranet/app-service-plan/azurerm to ~> 6.4.0 dbc2f66
* **deps:** update terraform claranet/storage-account/azurerm to ~> 7.10.0 4c9ea91

# v7.8.0 - 2023-10-20

Added
  * AZ-1218: Set by default application setting `PYTHON_ISOLATE_WORKER_DEPENDENCIES` to 1 for Python functions

Fixed
  * AZ-1133: Ignore `WEBSITE_CONTENTSHARE`, `WEBSITE_CONTENTAZUREFILECONNECTIONSTRING` & `FUNCTIONS_WORKER_RUNTIME` app settings for drift

# v7.7.0 - 2023-09-22

Added
  * AZ-1133: Add dynamic settings

# v7.6.0 - 2023-09-01

Breaking
  * AZ-1153: Remove `retention_days` parameters, it must be handled at destination level now. (for reference: [Provider issue](https://github.com/hashicorp/terraform-provider-azurerm/issues/23051))

# v7.5.1 - 2023-07-17

Fixed
  * AZ-1113: Update sub-modules READMEs (according to their example)

# v7.5.0 - 2023-04-28

Breaking
  * AZ-1056: Fix Function Storage Account name with `client_name`. Use `var.storage_account_custom_name` to keep your Storage Account when upgrading.

# v7.4.2 - 2023-04-13

Fixed
  * [GH-4](https://github.com/claranet/terraform-azurerm-function-app/pull/4): fix: disable always-on for elastic premium plans
  * AZ-1037: Update examples with `run` module

# v7.4.1 - 2023-03-31

Fixed
  * AZ-1042: Fix Windows Function outbound IPs and SAS resource condition

# v7.4.0 - 2023-03-28

Fixed
  * AZ-1037: Fix `ip_restriction` and `scm_ip_restriction` parameters

Added
  * AZ-1034: Add `sticky_settings` block and `site_config` parameters

# v7.3.2 - 2023-03-03

Fixed
  * AZ-1015: Fix Storage Account identity management on Function App staging slot

# v7.3.1 - 2023-03-03

Fixed
  * AZ-1015: Fix Storage Account identity management

# v7.3.0 - 2023-02-06

Added
  * AZ-965: Additional outputs
  * AZ-965: Allow Storage RBAC access

Changed
  * AZ-965: Rework variables files and descriptions
  * AZ-965: Dedicated variable for Storage Account creation

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
