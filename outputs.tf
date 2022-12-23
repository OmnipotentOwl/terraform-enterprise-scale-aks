output "virtual_network" {
  value       = azurerm_virtual_network.aks_vnet
  description = "virtual network object created by module"
}
output "network_resource_group" {
  value       = azurerm_resource_group.network
  description = "network resource group object created by module"
}
output "security_resource_group" {
  value       = azurerm_resource_group.security
  description = "security resource group object created by module"
}
output "cluster_resource_group" {
  value       = azurerm_resource_group.cluster
  description = "cluster resource group object created by module"
}
output "cluster_name" {
  value       = azurerm_kubernetes_cluster.k8s.name
  description = "name of the AKS cluster"
}
output "cluster_id" {
  value       = azurerm_kubernetes_cluster.k8s.id
  description = "id of the AKS cluster"
}
output "cluster_managed_resource_group_name" {
  value       = azurerm_kubernetes_cluster.k8s.node_resource_group
  description = "name of the AKS cluster managed resource group"
}
output "kubelet_identity" {
  value       = azurerm_kubernetes_cluster.k8s.kubelet_identity[0]
  description = "kubelet identity object of the AKS cluster"
}
output "app_gateway_user_managed_identity" {
  value       = azurerm_user_assigned_identity.app_gateway_secrets
  description = "user managed identity object of the App Gateway created by the module used for pulling secrets from Key Vault"
}
output "app_gateway" {
  value       = local.app_gateway_enabled ? azurerm_application_gateway.aks_ingress[0] : null
  description = "application gateway object created by module"
}
