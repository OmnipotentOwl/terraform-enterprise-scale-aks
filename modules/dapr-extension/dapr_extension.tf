resource "azurerm_kubernetes_cluster_extension" "dapr" {
  name           = "dapr"
  cluster_id     = var.aks_cluster.id
  extension_type = "Microsoft.Dapr"
  release_train  = "Stable"
  configuration_settings = merge({
    "global.ha.enabled" = "true"
    #tflint-ignore: terraform_deprecated_interpolation
    "global.mtls.enabled" = "${var.service_mesh_enabled ? "false" : "true"}"
    #tflint-ignore: terraform_deprecated_interpolation
    "dapr_placement.volumeclaims.storageClassName" = "${var.dapr_storage_class_name}"
  }, try(var.dapr_configuration_settings, {}))

  timeouts {
    create = "20m"
  }

  depends_on = [
    module.private_storage_class
  ]
}
