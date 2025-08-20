variable "runtime_name" {
  description = "The runtime name for the Function App. Possible values include `dotnet`, `dotnet-isolated`, `java`, `node`, `powershell`, `python`, and `custom`."
  type        = string
  default     = "dotnet-isolated"
}

variable "runtime_version" {
  description = "The runtime version for the Function App."
  type        = string
  default     = "8.0"
}

variable "service_plan_id" {
  description = "ID of the App Service Plan for the Function App. Required for flex consumption."
  type        = string
}

variable "application_settings" {
  description = "Function App application settings."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "application_settings_drift_ignore" {
  description = "Ignore drift from settings manually set."
  type        = bool
  default     = true
  nullable    = false
}

variable "identity_type" {
  description = "Add a Managed Identity (MSI) to the function app. Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned` which assigns both a system managed identity as well as the specified user assigned identities."
  type        = string
  default     = "SystemAssigned"
}

variable "identity_ids" {
  description = "User Assigned Identities IDs to add to Function App. Mandatory if type is `UserAssigned`."
  type        = list(string)
  default     = null
}

variable "public_network_access_enabled" {
  description = "Whether public network access is allowed for the function app."
  type        = bool
  default     = true
  nullable    = false
}

variable "allowed_ips" {
  description = "IPs restriction for Function in CIDR format. [See documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#ip_restriction)."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "allowed_subnet_ids" {
  description = "Subnets restriction for Function App. [See documentation](https://www.terraform.io/docs/providers/azurerm/r/function_app.html#ip_restriction)."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "ip_restriction_headers" {
  description = "IPs restriction headers for Function. [See documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#headers)."
  type        = map(list(string))
  default     = null
}

variable "allowed_service_tags" {
  description = "Service Tags restriction for Function App. [See documentation](https://www.terraform.io/docs/providers/azurerm/r/function_app.html#ip_restriction)."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "site_config" {
  description = "Site config for Function App. [See documentation](https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config). IP restriction attribute is not managed in this block."
  type        = any
  default     = {}
  nullable    = false
}

variable "sticky_settings" {
  description = "Lists of connection strings and app settings to prevent from swapping between slots."
  type = object({
    app_setting_names       = optional(list(string))
    connection_string_names = optional(list(string))
  })
  default = null
}

variable "https_only" {
  description = "Whether HTTPS traffic only is enabled."
  type        = bool
  default     = true
  nullable    = false
}

variable "client_certificate_enabled" {
  description = "Whether the Function App uses client certificates."
  type        = bool
  default     = null
}

variable "client_certificate_mode" {
  description = "The mode of the Function App's client certificates requirement for incoming requests. Possible values are `Required`, `Optional`, and `OptionalInteractiveUser`."
  type        = string
  default     = null
}

variable "application_zip_package_path" {
  description = "Local or remote path of a zip package to deploy on the Function App."
  type        = string
  default     = null
}

variable "auth_settings_v2" {
  description = "Authentication settings V2. [See documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app#auth_settings_v2)."
  type        = any
  default     = {}
  nullable    = false
}

# SCM parameters

variable "scm_allowed_ips" {
  description = "SCM IPs restriction for Function App. [See documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction)."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "scm_allowed_subnet_ids" {
  description = "SCM subnets restriction for Function App. [See documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction)."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "scm_ip_restriction_headers" {
  description = "IPs restriction headers for Function App. [See documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction)."
  type        = map(list(string))
  default     = null
}

variable "scm_allowed_service_tags" {
  description = "SCM Service Tags restriction for Function App. [See documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction)."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "storage_uses_managed_identity" {
  description = "Whether the Function App use Managed Identity to access the Storage Account. **Caution** This disable the storage keys on the Storage Account if created within the module."
  type        = bool
  default     = false
  nullable    = false
}

variable "storage_user_assigned_identity_id" {
  description = "The user assigned Managed Identity to access the storage account. Conflicts with `storage_access_key`."
  type        = string
  default     = null
  nullable    = true
}

# Flex-specific variables

variable "maximum_instance_count" {
  description = "The maximum number of instances for this Function App. Only affects apps on Flex Consumption plans."
  type        = number
  default     = 100
  nullable    = false
}

variable "always_ready_instance_count" {
  description = "The number of instances that are always ready and warm for this Function App. Only affects apps on Flex Consumption plans."
  type        = number
  default     = null
}

variable "instance_memory_mb" {
  description = "The amount of memory in megabytes allocated to each instance of the Function App. Possible values are `2048`, `4096`, `8192`, and `16384`."
  type        = number
  default     = 2048
  nullable    = false
  validation {
    condition     = contains([2048, 4096, 8192, 16384], var.instance_memory_mb)
    error_message = "The instance_memory_mb must be one of: 2048, 4096, 8192, 16384."
  }
}
