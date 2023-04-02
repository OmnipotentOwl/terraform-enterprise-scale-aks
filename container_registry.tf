resource "azurerm_role_assignment" "aks_sp_container_registry" {
  for_each = { for k, v in var.container_registies : k => v
  if v.id != null }

  scope                = each.value.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}

data "azurerm_container_registry" "aks_pull_acr" {
  for_each = { for k, v in var.container_registies : k => v
  if v.id == null }

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}
resource "azurerm_role_assignment" "aks_sp_container_registry_by_name" {
  for_each = { for k, v in var.container_registies : k => v
  if v.id == null }

  scope                = data.azurerm_container_registry.aks_pull_acr[each.key].id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}
