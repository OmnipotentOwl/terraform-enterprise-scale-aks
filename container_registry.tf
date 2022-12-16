resource "azurerm_role_assignment" "aks_sp_container_registry" {
  count = local.container_registry_defined ? 1 : 0

  scope                = var.container_registry.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}
