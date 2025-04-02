variable "use_existing_storage_account" {
  description = "Whether existing Storage Account should be used instead of creating a new one."
  type        = bool
  default     = false
}

variable "storage_account_id" {
  description = "ID of the existing Storage Account to use."
  type        = string
  default     = null
}

variable "storage_account_kind" {
  description = "Storage Account Kind."
  type        = string
  default     = "StorageV2"
}

variable "storage_account_min_tls_version" {
  description = "Storage Account minimal TLS version."
  type        = string
  default     = "TLS1_2"
}

variable "storage_account_advanced_threat_protection_enabled" {
  description = "Whether advanced threat protection is enabled. See documentation: https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection?tabs=azure-portal"
  type        = bool
  default     = false
}

variable "storage_account_https_traffic_only_enabled" {
  description = "Whether HTTPS traffic only is enabled for Storage Account."
  type        = bool
  default     = true
}

variable "storage_account_identity_type" {
  description = "Type of Managed Service Identity that should be configured on the Storage Account."
  type        = string
  default     = null
}

variable "storage_account_identity_ids" {
  description = "Specifies a list of User Assigned Managed Identity IDs to be assigned to the Storage Account."
  type        = list(string)
  default     = null
}

variable "storage_account_network_rules_enabled" {
  description = "Whether to enable Storage Account network default rules for functions."
  type        = bool
  default     = true
}

variable "storage_account_network_bypass" {
  description = "Whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of `Logging`, `Metrics`, `AzureServices`, or `None`."
  type        = list(string)
  default     = ["Logging", "Metrics", "AzureServices"]
}

variable "storage_account_allowed_ips" {
  description = "IPs restrictions for Function Storage Account in CIDR format."
  type        = list(string)
  default     = []
}

variable "storage_infrastructure_encryption_enabled" {
  description = "Boolean flag which enables infrastructure encryption.  Please refer to the [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#infrastructure_encryption_enabled) for more information."
  type        = bool
  default     = false
  nullable    = false
}

variable "rbac_storage_contributor_role_principal_ids" {
  description = "The principal IDs of the users, groups, and service principals to assign the `Storage Account Contributor` role to."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "rbac_storage_blob_role_principal_ids" {
  description = "The principal IDs of the users, groups, and service principals to assign the `Storage Blob Data *` different roles to if Blob containers are created."
  type = object({
    owners       = optional(list(string), [])
    contributors = optional(list(string), [])
    readers      = optional(list(string), [])
  })
  default  = {}
  nullable = false
}

variable "rbac_storage_file_role_principal_ids" {
  description = "The principal IDs of the users, groups, and service principals to assign the `Storage File Data *` different roles to if File Shares are created."
  type = object({
    privileged_contributors = optional(list(string), [])
    privileged_readers      = optional(list(string), [])
    smb_owners              = optional(list(string), [])
    smb_contributors        = optional(list(string), [])
    smb_readers             = optional(list(string), [])
  })
  default  = {}
  nullable = false
}

variable "rbac_storage_table_role_principal_ids" {
  description = "The principal IDs of the users, groups, and service principals to assign the `Storage Table Data *` role to."
  type = object({
    contributors = optional(list(string), [])
    readers      = optional(list(string), [])
  })
  default  = {}
  nullable = false
}

variable "rbac_storage_queue_contributor_role_principal_ids" {
  description = "The principal IDs of the users, groups, and service principals to assign the `Storage Queue Data *` role to."
  type = object({
    contributors = optional(list(string), [])
    readers      = optional(list(string), [])
  })
  default  = {}
  nullable = false
}
