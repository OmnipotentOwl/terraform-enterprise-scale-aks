
module "flux_gitops_github" {
  count  = can(var.aks_configuration.gitops_bootstrapping_github.organization_name) ? 1 : 0
  source = "./modules/flux2-github-bootstrap"

  cluster_name         = azurerm_kubernetes_cluster.k8s.name
  github_configuration = var.aks_configuration.gitops_bootstrapping_github
}
