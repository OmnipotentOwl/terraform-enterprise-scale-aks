output "virtual_network" {
  value = azurerm_virtual_network.aks_vnet
}
output "network_resource_group" {
  value = azurerm_resource_group.network
}
output "security_resource_group" {
  value = azurerm_resource_group.security
}
output "cluster_resource_group" {
  value = azurerm_resource_group.cluster
}
output "cluster_name" {
  value = local.aks_name
}
output "cluster_id" {
  value = azurerm_kubernetes_cluster.k8s.id
}
output "cluster_managed_resource_group_name" {
  value = azurerm_kubernetes_cluster.k8s.node_resource_group
}
output "kubelet_identity" {
  value = azurerm_kubernetes_cluster.k8s.kubelet_identity[0]
}
output "app_gateway_user_managed_identity" {
  value = azurerm_user_assigned_identity.app_gateway_secrets
}
output "app_gateway" {
  value = local.app_gateway_enabled ? azurerm_application_gateway.aks_ingress[0] : null
}