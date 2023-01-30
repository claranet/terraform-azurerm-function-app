variable "default_tags_enabled" {
  description = "Option to enable or disable default tags."
  type        = bool
  default     = true
}

variable "extra_tags" {
  description = "Extra tags to add."
  type        = map(string)
  default     = {}
}

variable "service_plan_extra_tags" {
  description = "Extra tags to add to Service Plan."
  type        = map(string)
  default     = {}
}

variable "application_insights_extra_tags" {
  description = "Extra tags to add to Application Insights."
  type        = map(string)
  default     = {}
}

variable "function_app_extra_tags" {
  description = "Extra tags to add to Function App."
  type        = map(string)
  default     = {}
}

variable "storage_account_extra_tags" {
  description = "Extra tags to add to Storage Account."
  type        = map(string)
  default     = {}
}
