terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.24"
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
  }
  required_version = "~> 1.3.0"
}
provider "github" {
  owner = can(var.aks_configuration.gitops_bootstrapping_github.organization_name) ? var.aks_configuration.gitops_bootstrapping_github.organization_name : null
}
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.k8s.kube_admin_config[0].host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config[0].cluster_ca_certificate)
  client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config[0].client_key)
}

provider "kubectl" {
  host                   = azurerm_kubernetes_cluster.k8s.kube_admin_config[0].host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config[0].cluster_ca_certificate)
  client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config[0].client_key)
  apply_retry_count      = 10
}
