data "github_repository" "main" {
  full_name = "${var.github_configuration.organization_name}/${var.github_configuration.repository_name}"
}

resource "github_repository_deploy_key" "main" {
  title      = "flux-cluster-${var.cluster_name}"
  repository = data.github_repository.main.name
  key        = tls_private_key.main.public_key_openssh
  read_only  = true
}

resource "github_repository_file" "install" {
  repository = data.github_repository.main.name
  file       = data.flux_install.main.path
  content    = data.flux_install.main.content
  branch     = var.github_configuration.branch_name
}

resource "github_repository_file" "sync" {
  repository = data.github_repository.main.name
  file       = data.flux_sync.main.path
  content    = data.flux_sync.main.content
  branch     = var.github_configuration.branch_name
}

resource "github_repository_file" "kustomize" {
  repository          = data.github_repository.main.name
  file                = data.flux_sync.main.kustomize_path
  content             = data.flux_sync.main.kustomize_content
  branch              = var.github_configuration.branch_name
  overwrite_on_create = true
}
resource "github_repository_file" "patches" {
  #  `patch_file_paths` is a map keyed by the keys of `flux_sync.main`
  #  whose values are the paths where the patch files should be installed.
  for_each = data.flux_sync.main.patch_file_paths

  repository = data.github_repository.main.name
  file       = each.value
  content    = local.flux_patches[each.key] # Get content of our patch files
  branch     = var.github_configuration.branch_name
}
