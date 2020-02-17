variable "client_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "stack" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  description = "Azure location for App Service Plan."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "name_prefix" {
  description = "Name prefix for all resources generated name"
  type        = string
  default     = ""
}

variable "function_app_name_prefix" {
  description = "Function App name prefix"
  type        = string
  default     = ""
}

variable "application_insights_name_prefix" {
  description = "Application Insights name prefix"
  type        = string
  default     = ""
}

variable "storage_account_name_prefix" {
  description = "Storage Account name prefix"
  type        = string
  default     = ""
}

variable "storage_account_kind" {
  description = "Storage Account Kind"
  type        = string
  default     = "StorageV2"
}

variable "storage_account_enable_advanced_threat_protection" {
  description = "Boolean flag which controls if advanced threat protection is enabled, see [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal) for more information."
  type        = bool
  default     = false
}

variable "storage_account_enable_https_traffic_only" {
  description = "Boolean flag which controls if https traffic only is enabled."
  type        = bool
  default     = true
}

variable "app_service_plan_id" {
  description = "Id of the App Service Plan for Function App hosting"
  type        = string
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

variable "storage_account_extra_tags" {
  description = "Extra tags to add to Storage Account"
  type        = map(string)
  default     = {}
}

variable "application_insights_extra_tags" {
  description = "Extra tags to add to Application Insights"
  type        = map(string)
  default     = {}
}

variable "function_app_extra_tags" {
  description = "Extra tags to add to Function App"
  type        = map(string)
  default     = {}
}

variable "function_language_for_linux" {
  description = "Language of the Function App on Linux hosting, can be \"dotnet\", \"node\" or \"python\""
  type        = string
  default     = "dotnet"
}

# TODO Remove me in Terraform 0.12
variable "create_storage_account_resource" {
  description = "Flag indicating if Storage Account resource should be automatically created (needed until Terraform 0.12), otherwise, variable `storage_account_connection_string` must be set. Default to `true`"
  type        = string
  default     = "true"
}

variable "storage_account_connection_string" {
  description = "Storage Account connection string for Function App associated storage, a Storage Account is created if empty"
  type        = string
  default     = ""
}

# TODO Remove me in Terraform 0.12
variable "create_application_insights_resource" {
  description = "Flag indicating if Application Insights resource should be automatically created (needed until Terraform 0.12), otherwise, variable `application_insights_instrumentation_key` must be set. Default to `true`"
  type        = string
  default     = "true"
}

variable "application_insights_instrumentation_key" {
  description = "Application Insights instrumentation key for function logs, generated if empty"
  type        = string
  default     = ""
}

variable "application_insights_type" {
  description = "Application Insights type if need to be generated"
  type        = string
  default     = "Web"
}

variable "function_app_application_settings" {
  description = "Function App application settings"
  type        = map(string)
  default     = {}
}

