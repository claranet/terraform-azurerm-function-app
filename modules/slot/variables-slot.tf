variable "slot_os_type" {
  description = "The O/S type for the Function App slot. Possible values include `Windows`, `Linux`, `Container`, and `Flex` (when supported)."
  type        = string
}

variable "function_app_id" {
  description = "The ID of the Function App to create the slot for."
  type        = string
}

variable "storage_account_name" {
  description = "The backend storage account name which will be used by this Function App slot."
  type        = string
}

variable "storage_account_access_key" {
  description = "The access key which will be used to access the backend storage account for the Function App slot."
  type        = string
  default     = null
  sensitive   = true
}

variable "storage_uses_managed_identity" {
  description = "Should the Function App slot use Managed Identity to access the storage account."
  type        = bool
  default     = false
}

variable "functions_extension_version" {
  description = "The runtime version associated with the Function App slot."
  type        = string
  default     = "~4"
}

variable "site_config" {
  description = "Site config for Function App slot. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#site_config). IP restriction attribute is no more managed in this block."
  type        = any
  default     = {}
}

variable "app_settings" {
  description = "Application settings for Function App slot. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#app_settings)."
  type        = map(string)
  default     = {}
}

variable "connection_strings" {
  description = "Connection strings for Function App slot. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#connection_string)."
  type        = list(map(string))
  default     = []
}

variable "auth_settings_v2" {
  description = "Authentication settings V2. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#auth_settings_v2)."
  type        = any
  default     = {}
}

variable "auth_settings_v2_login" {
  description = "Values for the authentication settings V2 login block."
  type        = any
  default     = {}
}

variable "https_only" {
  description = "HTTPS restriction for Function App slot. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#https_only)."
  type        = bool
  default     = false
}

variable "builtin_logging_enabled" {
  description = "Should built in logging be enabled. Configures `AzureWebJobsDashboard` app setting based on the configured storage setting."
  type        = bool
  default     = true
}

variable "client_certificate_enabled" {
  description = "Should the Function App slot use Client Certificates."
  type        = bool
  default     = null
}

variable "client_certificate_mode" {
  description = "The mode of the Function App slot's client certificates requirement for incoming requests. Possible values are `Required`, `Optional`, and `OptionalInteractiveUser`."
  type        = string
  default     = null
}

variable "identity" {
  description = "Map with identity block information."
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = {
    type         = "SystemAssigned"
    identity_ids = []
  }
}

variable "key_vault_reference_identity_id" {
  description = "The User Assigned Identity ID to use for the Key Vault secrets reference. If not set, the system assigned identity of the Function App slot will be used."
  type        = string
  default     = null
}

variable "mount_points" {
  description = "Storage Account mount points. Name is generated if not set and default type is `AzureFiles`. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#storage_account)."
  type = list(object({
    name         = optional(string)
    type         = optional(string, "AzureFiles")
    account_name = string
    share_name   = string
    access_key   = string
    mount_path   = optional(string)
  }))
  validation {
    condition     = alltrue([for m in var.mount_points : contains(["AzureBlob", "AzureFiles"], m.type)])
    error_message = "The `type` attribute of `var.mount_points` object list must be `AzureBlob` or `AzureFiles`."
  }
  default  = []
  nullable = false
}
