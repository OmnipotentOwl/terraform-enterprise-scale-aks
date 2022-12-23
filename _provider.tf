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
