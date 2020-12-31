# v4.0.0 - Unreleased

Updated
  * AZ-273: Module now compatible terraform `v0.13+`

Added
  * AZ-347 Allow to use custom name
 
# v3.1.0 - 2020-12-10

Fixed
  * AZ-245: Force azurerm 2.21.0 to avoid bug with linux function app
 
Breaking
  * AZ-246: Add missing variable to pass runtime version to function-app-single module + Add missing identity variables + Fix some default values.
  
# v3.0.0 - 2020-07-30

Breaking
  * AZ-206: Provider Azure v2.x+ upgrade

# v2.0.1 - 2019-11-15

Fixed
  * AZ-118: Documentation update for public release 

# v2.0.0 - 2019-11-14

Breaking
  * AZ-94: Upgrade module to terraform 0.12/ HCL2
  
Added
  * AZ-118: Add LICENSE, NOTICE files + Add badges in README
  * AZ-119: Revamp to match Terraform/Hashicorp best practices
  
# v1.1.0 - 2019-05-15

Added
  * AZ-78: Windows support

# v1.0.0 - 2019-04-23

Added
  * AZ-47: First release
