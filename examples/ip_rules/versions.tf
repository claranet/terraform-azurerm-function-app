terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0"
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