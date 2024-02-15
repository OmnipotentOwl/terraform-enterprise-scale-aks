terraform {
  required_version = ">= 1.3.8"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.65.0"
    }
  }
}
