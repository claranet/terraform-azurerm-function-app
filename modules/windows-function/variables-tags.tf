variable "application_insights_extra_tags" {
  description = "Extra tags to add to Application Insights"
  type        = map(string)
  default     = {}
}

variable "authorized_service_tags" {
  description = "Service Tags restriction for Function. See documentation https://www.terraform.io/docs/providers/azurerm/r/function_app.html#ip_restriction"
  type        = list(string)
  default     = []
}

variable "default_tags_enabled" {
  description = "Option to enable or disable default tags"
  type        = bool
  default     = true
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

variable "function_app_extra_tags" {
  description = "Extra tags to add to Function App"
  type        = map(string)
  default     = {}
}

variable "scm_authorized_service_tags" {
  description = "SCM Service Tags restriction for Function. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction"
  type        = list(string)
  default     = []
}

variable "storage_account_extra_tags" {
  description = "Extra tags to add to Storage Account"
  type        = map(string)
  default     = {}
}
