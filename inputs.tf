variable "client_name" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "stack" {
  type = "string"
}

variable "resource_group_name" {
  type = "string"
}

variable "location" {
  description = "Azure location for App Service Plan."
  type        = "string"
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = "string"
}

variable "short_name" {
  description = "Function name"
  type        = "string"
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = "map"
  default     = {}
}

variable "app_service_plan_extra_tags" {
  description = "Extra tags to add to App Service Plan"
  type        = "map"
  default     = {}
}

variable "storage_account_extra_tags" {
  description = "Extra tags to add to Storage Account"
  type        = "map"
  default     = {}
}

variable "application_insights_extra_tags" {
  description = "Extra tags to add to Application Insights"
  type        = "map"
  default     = {}
}

variable "function_app_extra_tags" {
  description = "Extra tags to add to Function App"
  type        = "map"
  default     = {}
}

variable "function_language" {
  description = "Language of the function, can be \"dotnet\", \"node\" or \"python\""
  type        = "string"
}

variable "storage_account_connection_string" {
  description = "Storage Account connection string for Function App associated storage, a Storage Account is created if empty"
  type        = "string"
  default     = ""
}

variable "application_insights_instrumentation_key" {
  description = "Application Insights instrumentation key for function logs, generated if empty"
  type        = "string"
  default     = ""
}

variable "application_insights_type" {
  description = "Application Insights type if need to be generated"
  type        = "string"
  default     = "Web"
}

variable "function_app_application_settings" {
  description = "Function App application settings"
  type        = "map"
  default     = {}
}
