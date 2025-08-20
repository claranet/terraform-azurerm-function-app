terraform {
  # https://github.com/terraform-linters/tflint/blob/v0.33.2/docs/rules/terraform_unused_required_providers.md
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.35"
    }
    azurecaf = {
      source  = "claranet/azurecaf"
      version = "~> 1.2.28"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.0"
    }
  }
}
