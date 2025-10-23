# Network/firewall variables

variable "public_network_access_enabled" {
  description = "Whether the Azure Function App slot is available from public network."
  type        = bool
  default     = false
}

variable "vnet_integration_subnet_id" {
  description = "ID of the subnet to associate with the Function App slot."
  type        = string
  default     = null
}

variable "ip_restriction" {
  description = "IP restriction for Function App slot. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#ip_restriction)."
  type        = any
  default     = {}
}

variable "scm_ip_restriction" {
  description = "SCM IP restriction for Function App slot. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#scm_ip_restriction)."
  type        = any
  default     = {}
}

variable "scm_allowed_cidrs" {
  description = "SCM IPs restriction for Function App slot. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#scm_ip_restriction)."
  type        = list(string)
  default     = []
}

variable "scm_allowed_subnet_ids" {
  description = "SCM subnets restriction for Function App slot. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app_slot#scm_ip_restriction)."
  type        = list(string)
  default     = []
}
