terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.36"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.5"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">=0.6"
    }
    github = {
      source  = "integrations/github"
      version = ">= 4.5.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.10.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.2.23"
    }
  }
  required_version = ">= 1.3.0"
}
