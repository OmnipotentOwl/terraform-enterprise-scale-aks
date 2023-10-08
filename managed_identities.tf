resource "azurecaf_name" "azurerm_user_assigned_identity_cluster_control_plane" {
  count = local.use_user_assigned_managed_identity ? 1 : 0

  name          = azurecaf_name.azurerm_kubernetes_cluster_k8s.result
  resource_type = "azurerm_user_assigned_identity"
  suffixes = [
    "cluster"
  ]
  clean_input = true
}
resource "azurerm_user_assigned_identity" "cluster_control_plane" {
  count = local.use_user_assigned_managed_identity ? 1 : 0

  name                = azurecaf_name.azurerm_user_assigned_identity_cluster_control_plane[0].result
  resource_group_name = local.security_resource_group.name
  location            = local.security_resource_group.location
}
resource "azurecaf_name" "azurerm_user_assigned_identity_app_gateway_secrets" {
  count = local.app_gateway_enabled ? 1 : 0

  name          = azurecaf_name.azurerm_application_gateway_aks_ingress[0].result
  resource_type = "azurerm_user_assigned_identity"
  suffixes = [
    "secrets"
  ]
  clean_input = true
}
resource "azurerm_user_assigned_identity" "app_gateway_secrets" {
  count = local.app_gateway_enabled ? 1 : 0

  name                = azurecaf_name.azurerm_user_assigned_identity_app_gateway_secrets[0].result
  resource_group_name = local.security_resource_group.name
  location            = local.security_resource_group.location
}
resource "azurecaf_name" "azurerm_user_assigned_identity_app_gateway_controller" {
  count = local.app_gateway_enabled ? 1 : 0

  name          = azurecaf_name.azurerm_application_gateway_aks_ingress[0].result
  resource_type = "azurerm_user_assigned_identity"
  suffixes = [
    "controller"
  ]
  clean_input = true
}
resource "azurerm_user_assigned_identity" "app_gateway_controller" {
  count = local.app_gateway_enabled ? 1 : 0

  name                = azurecaf_name.azurerm_user_assigned_identity_app_gateway_controller[0].result
  resource_group_name = local.security_resource_group.name
  location            = local.security_resource_group.location
}

resource "azurerm_role_assignment" "app_gateway_controller_app_gateway_contributor" {
  count = local.app_gateway_enabled ? 1 : 0

  scope                = azurerm_application_gateway.aks_ingress[0].id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.app_gateway_controller[0].principal_id
}
resource "azurerm_role_assignment" "app_gateway_controller_app_gateway_rg_reader" {
  count = local.app_gateway_enabled ? 1 : 0

  scope                = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].id : azurerm_resource_group.network[0].id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.app_gateway_controller[0].principal_id
}
resource "azurerm_role_assignment" "app_gateway_controller_app_gateway_secrets_managed_identity_operator" {
  count = local.app_gateway_enabled ? 1 : 0

  scope                = azurerm_user_assigned_identity.app_gateway_secrets[0].id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.app_gateway_controller[0].principal_id
}
resource "azurerm_role_assignment" "cluster_control_plane_vnet_dns_zone_contributor" {
  count = local.private_cluster_enabled ? 1 : 0

  scope                = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].id : azurerm_virtual_network.aks_vnet[0].id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.cluster_control_plane[0].principal_id
}
resource "azurerm_role_assignment" "cluster_control_plane_private_zone_dns_zone_contributor" {
  count = local.private_cluster_enabled ? 1 : 0

  scope                = var.aks_configuration.private_cluster.private_dns_zone_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.cluster_control_plane[0].principal_id
}
resource "azurerm_role_assignment" "oms_agent_monitoring_metrics_publisher" {
  count = var.aks_configuration.oms_agent != null ? 1 : 0

  scope                = azurerm_kubernetes_cluster.k8s.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_kubernetes_cluster.k8s.oms_agent[0].oms_agent_identity[0].object_id
}
