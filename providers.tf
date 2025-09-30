terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.35"
    }
    azurecaf = {
      source  = "claranet/azurecaf"
      version = ">= 1.2.28"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.0"
    }
  }
}
