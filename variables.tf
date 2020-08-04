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
  description = "Azure location for Function App and related resources"
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location"
  type        = string
}

variable "name_prefix" {
  description = "Name prefix for all resources generated name"
  type        = string
  default     = ""
}

variable "app_service_plan_name_prefix" {
  description = "App Service Plan name prefix"
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

variable "app_service_plan_sku" {
  description = "App Service Plan sku if created, consumption plan by default"
  type        = map(string)

  default = {
    size = "Y1"
    tier = "Dynamic"
  }
}

variable "app_service_plan_os" {
  description = "App Service Plan OS for dedicated plans, can be \"Linux\" or \"Windows\""
  type        = string
}

variable "app_service_plan_reserved" {
  description = "Flag indicating if dedicated App Service Plan should be reserved"
  type        = string
  default     = "false"
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

variable "app_service_plan_extra_tags" {
  description = "Extra tags to add to App Service Plan"
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

variable "application_insights_instrumentation_key" {
  description = "Application Insights instrumentation key for function logs, generated if null"
  type        = string
  default     = null
}

variable "application_insights_type" {
  description = "Application Insights type if need to be generated"
  type        = string
  default     = "web"
}

variable "function_app_application_settings" {
  description = "Function App application settings"
  type        = map(string)
  default     = {}
}

variable "function_app_version" {
  description = "Version of the function app runtime to use (Allowed values 2 or 3)"
  type        = number
  default     = 3
}

variable "identity_type" {
  description = "Add an Identity (MSI) to the function app. Possible values are SystemAssigned or UserAssigned"
  type        = string
  default     = null
}

variable "identity_ids" {
  description = "UserAssigned Identities ID to add to Function App. Mandatory if type is UserAssigned"
  type        = list(string)
  default     = null
}