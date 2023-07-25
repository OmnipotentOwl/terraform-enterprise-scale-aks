provider "flux" {
  kubernetes = {
    host                   = var.kubernetes_configuration.host
    client_certificate     = var.kubernetes_configuration.client_certificate
    client_key             = var.kubernetes_configuration.client_key
    cluster_ca_certificate = var.kubernetes_configuration.cluster_ca_certificate
  }
  git = {
    url = "ssh://git@github.com/${var.github_configuration.organization_name}/${var.github_configuration.repository_name}.git"
    ssh = {
      username    = "git"
      private_key = tls_private_key.flux.private_key_pem
    }
  }
}
