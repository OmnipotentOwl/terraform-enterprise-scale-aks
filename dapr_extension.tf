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
      }
      releaseTrain = "Stable"
    }
  })
  ignore_missing_property = true
  timeouts {
    create = "20m"
  }
}
