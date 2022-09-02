terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.19"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}
