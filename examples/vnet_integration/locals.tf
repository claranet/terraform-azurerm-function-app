locals {
  vnet_cidr = "10.10.0.0/16"
  # subnets = [
  #   {
  #     name              = "subnet-function-app"
  #     cidrs             = ["10.10.0.0/24"]
  #     service_endpoints = ["Microsoft.Storage"]
  #   },
  #   {
  #     name              = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-subnet2"
  #     cidrs             = ["10.10.1.0/24"]
  #     service_endpoints = []
  #   },
  # ]
}
