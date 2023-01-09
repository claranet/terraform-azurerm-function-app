variable "os_type" {
  description = "OS type for the Functions to be hosted in the Service Plan. Possible values include `Windows`, `Linux`, and `WindowsContainer`."
  type        = string
}

variable "sku_name" {
  description = "The SKU for the Service Plan. Possible values include B1, B2, B3, D1, F1, I1, I2, I3, I1v2, I2v2, I3v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, S1, S2, S3, SHARED, EP1, EP2, EP3, WS1, WS2, WS3, and Y1."
  type        = string
  default     = "Y1"
}

variable "app_service_environment_id" {
  description = "ID of the App Service Environment to create this Service Plan in. Requires an Isolated SKU. Use one of I1, I2, I3 for azurerm_app_service_environment, or I1v2, I2v2, I3v2 for azurerm_app_service_environment_v3."
  type        = string
  default     = null
}

variable "worker_count" {
  description = "Number of Workers (instances) to be allocated."
  type        = number
  default     = null
}

variable "maximum_elastic_worker_count" {
  description = "Maximum number of workers to use in an Elastic SKU Plan. Cannot be set unless using an Elastic SKU."
  type        = number
  default     = null
}

variable "per_site_scaling_enabled" {
  description = "Should per site scaling be enabled on the Service Plan."
  type        = bool
  default     = false
}
