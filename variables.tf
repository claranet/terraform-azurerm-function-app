variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure location for Function App and related resources"
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location"
  type        = string
}

variable "function_app_version" {
  description = "Version of the function app runtime to use (Allowed values 2 or 3)"
  type        = number
  default     = 3
}

variable "storage_account_access_key" {
  description = "Access key the storage account to use. If null a new storage account is created"
  type        = string
  default     = null
}

variable "storage_account_kind" {
  description = "Storage Account Kind"
  type        = string
  default     = "StorageV2"
}

variable "storage_account_min_tls_version" {
  description = "Storage Account minimal TLS version"
  type        = string
  default     = "TLS1_2"
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

variable "storage_account_identity_type" {
  description = "Specifies the type of Managed Service Identity that should be configured on this Storage Account"
  type        = string
  default     = null
}

variable "storage_account_identity_ids" {
  description = "Specifies a list of User Assigned Managed Identity IDs to be assigned to this Storage Account"
  type        = list(string)
  default     = null
}

variable "storage_account_network_rules_enabled" {
  description = "Enable Storage account network default rules for functions"
  type        = bool
  default     = true
}

variable "storage_account_network_bypass" {
  description = "Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of `Logging`, `Metrics`, `AzureServices`, or `None`."
  type        = list(string)
  default     = ["Logging", "Metrics", "AzureServices"]
}

variable "storage_account_authorized_ips" {
  description = "IPs restriction for Function storage account in CIDR format"
  type        = list(string)
  default     = []
}

variable "application_insights_enabled" {
  description = "Enable or disable the Application Insights deployment"
  type        = bool
  default     = true
}

variable "application_insights_id" {
  description = "ID of the existing Application Insights to use instead of deploying a new one."
  type        = string
  default     = null
}

variable "application_insights_type" {
  description = "Application Insights type if need to be generated. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights#application_type"
  type        = string
  default     = "web"
}

variable "application_insights_daily_data_cap" {
  description = "Daily data volume cap (in GB) for Application Insights"
  type        = number
  default     = null
}

variable "application_insights_daily_data_cap_notifications_disabled" {
  description = "Disable email notifications when data volume cap is met"
  type        = bool
  default     = null
}

variable "application_insights_retention" {
  description = "Specify retention period (in days) for logs"
  type        = number
  default     = 90
}

variable "application_insights_internet_ingestion_enabled" {
  description = "Enable ingestion support from Application Insights component over the Public Internet"
  type        = bool
  default     = true
}

variable "application_insights_internet_query_enabled" {
  description = "Enable querying support from Application Insights component over the Public Internet"
  type        = bool
  default     = true
}

variable "application_insights_ip_masking_disabled" {
  description = "Disable IP masking in logs"
  type        = bool
  default     = false
}

variable "application_insights_local_authentication_disabled" {
  description = "Disable Non-Azure AD based Auth"
  type        = bool
  default     = false
}

variable "application_insights_force_customer_storage_for_profiler" {
  description = "Enable Application Insights component to force users to create their own storage account for profiling"
  type        = bool
  default     = false
}

variable "function_app_application_settings" {
  description = "Function App application settings"
  type        = map(string)
  default     = {}
}

variable "application_insights_log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace to be used with Application Insights"
  type        = string
  default     = null
}

variable "application_insights_sampling_percentage" {
  description = "Percentage of data produced by the monitored application sampled for Application Insights telemetry"
  type        = number
  default     = null
}

variable "identity_type" {
  description = "Add an Identity (MSI) to the function app. Possible values are SystemAssigned or UserAssigned"
  type        = string
  default     = "SystemAssigned"
}

variable "identity_ids" {
  description = "UserAssigned Identities ID to add to Function App. Mandatory if type is UserAssigned"
  type        = list(string)
  default     = null
}

variable "authorized_ips" {
  description = "IPs restriction for Function in CIDR format. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#ip_restriction"
  type        = list(string)
  default     = []
}

variable "authorized_subnet_ids" {
  description = "Subnets restriction for Function. See documentation https://www.terraform.io/docs/providers/azurerm/r/function_app.html#ip_restriction"
  type        = list(string)
  default     = []
}

variable "ip_restriction_headers" {
  description = "IPs restriction headers for Function. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#headers"
  type        = map(list(string))
  default     = null
}

variable "function_app_vnet_integration_subnet_id" {
  description = "ID of the subnet to associate with the Function App (VNet integration)"
  type        = string
  default     = null
}

variable "function_app_site_config" {
  description = "Site config for Function App. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is not managed in this block."
  type        = any
  default     = {}
}

variable "https_only" {
  description = "Disable http procotol and keep only https"
  type        = bool
  default     = true
}

variable "builtin_logging_enabled" {
  description = "Should built in logging be enabled"
  type        = bool
  default     = true
}

variable "client_certificate_enabled" {
  description = "Should the function app use Client Certificates"
  type        = bool
  default     = null
}

variable "client_certificate_mode" {
  description = "(Optional) The mode of the Function App's client certificates requirement for incoming requests. Possible values are `Required`, `Optional`, and `OptionalInteractiveUser`."
  type        = string
  default     = null
}

variable "application_zip_package_path" {
  description = "Local or remote path of a zip package to deploy on the Function App"
  type        = string
  default     = null
}

variable "staging_slot_enabled" {
  description = "Create a staging slot alongside the Function App for blue/green deployment purposes."
  type        = bool
  default     = false
}

variable "staging_slot_custom_application_settings" {
  description = "Override staging slot with custom application settings."
  type        = map(string)
  default     = null
}

# SCM parameters

variable "scm_authorized_ips" {
  description = "SCM IPs restriction for Function. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction"
  type        = list(string)
  default     = []
}

variable "scm_authorized_subnet_ids" {
  description = "SCM subnets restriction for Function. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction"
  type        = list(string)
  default     = []
}

variable "scm_ip_restriction_headers" {
  description = "IPs restriction headers for Function. See documentation https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app#scm_ip_restriction"
  type        = map(list(string))
  default     = null
}
