resource "azapi_resource" "dapr_addon" {
  count = var.aks_configuration.managed_addons.dapr ? 1 : 0

  type      = "Microsoft.KubernetesConfiguration/extensions@2022-07-01"
  name      = "dapr"
  parent_id = azurerm_kubernetes_cluster.k8s.id
  locks     = [azurerm_kubernetes_cluster.k8s.id]
  body = jsonencode({
    properties = {
      extensionType           = "Microsoft.Dapr"
      autoUpgradeMinorVersion = true
      configurationSettings = {
        "global.ha.enabled" = "true"
        #tflint-ignore: terraform_deprecated_interpolation
        "global.mtls.enabled" = "${var.aks_configuration.managed_addons.open_service_mesh ? "false" : "true"}"
        #tflint-ignore: terraform_deprecated_interpolation
        "dapr_placement.volumeclaims.storageClassName" = "${local.private_cluster_defined ? local.use_built_in_storage_class ? module.private_storage_class.standard_files_storage_class_name : var.aks_configuration.private_cluster.private_storage.existing_storage_class_name : "azurefile-csi"}"
      }
      releaseTrain = "Stable"
    }
  })
  ignore_missing_property = true
  timeouts {
    create = "20m"
  }
  depends_on = [
    azurerm_kubernetes_cluster.k8s,
    azurerm_kubernetes_cluster_node_pool.worker_pool,
    module.private_storage_class
  ]
}
