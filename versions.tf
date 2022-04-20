terraform {
  required_version = ">= 0.13"

  # https://github.com/terraform-linters/tflint/blob/v0.33.2/docs/rules/terraform_unused_required_providers.md
  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.71"
    }
    # tflint-ignore: terraform_unused_required_providers
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.1"
    }
  }
}
