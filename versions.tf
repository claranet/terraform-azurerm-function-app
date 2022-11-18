terraform {
  required_version = ">= 1.3"

  # https://github.com/terraform-linters/tflint/blob/v0.33.2/docs/rules/terraform_unused_required_providers.md
  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.25"
    }
    # tflint-ignore: terraform_unused_required_providers
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2, >= 1.2.22"
    }
  }
}
