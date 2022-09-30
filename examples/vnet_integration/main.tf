terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.19"
    }
  }
}

provider "azurerm" {
  features {}
}
