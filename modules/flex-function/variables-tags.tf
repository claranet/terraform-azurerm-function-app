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

variable "function_app_extra_tags" {
  description = "Extra tags to add to Function App."
  type        = map(string)
  default     = {}
}
