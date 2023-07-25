resource "azurerm_kubernetes_cluster_extension" "dapr" {
  count          = try(var.aks_configuration.managed_addons.dapr.enabled != null, false) ? 1 : 0
  name           = "dapr"
  cluster_id     = azurerm_kubernetes_cluster.k8s.id
  extension_type = "Microsoft.Dapr"
  release_train  = "Stable"
  configuration_settings = merge({
    "global.ha.enabled" = "true"
    #tflint-ignore: terraform_deprecated_interpolation
    "global.mtls.enabled" = "${local.service_mesh_enabled ? "false" : "true"}"
    #tflint-ignore: terraform_deprecated_interpolation
    "dapr_placement.volumeclaims.storageClassName" = "${local.private_cluster_enabled ? local.use_built_in_storage_class ? module.private_storage_class.standard_files_storage_class_name : var.aks_configuration.private_cluster.private_storage.existing_storage_class_name : "azurefile-csi"}"
  }, try(var.aks_configuration.managed_addons.dapr_configuration_settings, {}))

  timeouts {
    create = "20m"
  }

  depends_on = [
    azurerm_kubernetes_cluster.k8s,
    azurerm_kubernetes_cluster_node_pool.worker_pool,
    module.private_storage_class
  ]
}
