resource "flux_bootstrap_git" "this" {
  path = local.target_path
  components_extra = [
    "image-reflector-controller",
    "image-automation-controller"
  ]
  registry = var.flux_configuration.registry
  version  = var.flux_configuration.version
  toleration_keys = setunion([
    "CriticalAddonsOnly"
  ], var.flux_configuration.additional_tolerations)

  kustomization_override = coalesce(var.flux_configuration.kustomization_overrides, local.built_in_kustomization)

  depends_on = [
    github_repository_deploy_key.this
  ]

  lifecycle {
    replace_triggered_by = [
      random_id.k8s_tracker.id
    ]
  }
}
