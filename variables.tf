variable "client_name" {
  description = "Client name/account used in naming."
  type        = string
}

variable "environment" {
  description = "Project environment."
  type        = string
}

variable "stack" {
  description = "Project stack name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure location for Function App and related resources."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}
