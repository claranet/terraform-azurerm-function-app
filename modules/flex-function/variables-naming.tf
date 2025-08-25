# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name."
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name."
  type        = string
  default     = ""
}

# Custom naming override
variable "function_app_name_prefix" {
  description = "Function App name prefix."
  type        = string
  default     = ""
}

variable "custom_name" {
  description = "Custom name for function app."
  type        = string
  default     = ""
}

variable "application_insights_name_prefix" {
  description = "Application Insights name prefix."
  type        = string
  default     = ""
}

variable "application_insights_custom_name" {
  description = "Custom name for application insights deployed with function app."
  type        = string
  default     = ""
}

variable "storage_account_name_prefix" {
  description = "Storage Account name prefix."
  type        = string
  default     = ""
}

variable "storage_account_custom_name" {
  description = "Custom name of the Storage account to attach to function."
  type        = string
  default     = null
}
