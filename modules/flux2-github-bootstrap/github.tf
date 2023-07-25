data "github_repository" "main" {
  full_name = "${var.github_configuration.organization_name}/${var.github_configuration.repository_name}"
}

resource "github_repository_deploy_key" "this" {
  title      = "flux-cluster-${var.cluster_name}"
  repository = data.github_repository.main.name
  key        = tls_private_key.flux.public_key_openssh
  read_only  = false
}
