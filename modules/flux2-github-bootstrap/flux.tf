data "flux_install" "main" {
  target_path = local.target_path
  components_extra = [
    "image-reflector-controller",
    "image-automation-controller"
  ]
}

data "flux_sync" "main" {
  target_path = local.target_path
  url         = "ssh://git@github.com/${var.github_configuration.organization_name}/${var.github_configuration.repository_name}.git"
  branch      = var.github_configuration.branch_name
  patch_names = keys(local.flux_patches)
}