terraform {
  required_version = ">= 1.12"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
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
