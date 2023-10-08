resource "azurerm_role_assignment" "aks_sp_container_registry" {
  for_each = var.aks_configuration.container_registries

  scope                = each.value.id != null ? each.value.id : each.value.lz_key != null ? var.container_registries[each.value.lz_key][each.value.key].id : var.container_registries[each.value.key].id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}

# TODO: solve issue with using data source for container registry
# data "azurerm_container_registry" "aks_pull_acr" {
#   for_each = { for key in var.aks_configuration.container_registry_keys : key => key
#   if var.container_registries[key].id == null && var.container_registries[key].name != null }

#   name                = var.container_registries[each.key].name
#   resource_group_name = var.container_registries[each.key].resource_group_name
# }
# resource "azurerm_role_assignment" "aks_sp_container_registry_by_name" {
#   for_each = { for key in var.aks_configuration.container_registry_keys : key => key
#   if var.container_registries[key].id == null && var.container_registries[key].name != null }

#   scope                = data.azurerm_container_registry.aks_pull_acr[each.key].id
#   role_definition_name = "AcrPull"
#   principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
# }
