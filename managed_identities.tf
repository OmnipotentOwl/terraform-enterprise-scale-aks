resource "azurerm_user_assigned_identity" "cluster_control_plane" {
  count = local.private_cluster_defined ? 1 : 0

  name                = "id-${local.aks_name}-cluster"
  resource_group_name = azurerm_resource_group.security.name
  location            = azurerm_resource_group.security.location
}
resource "azurerm_user_assigned_identity" "app_gateway_secrets" {
  count = local.app_gateway_enabled ? 1 : 0

  name                = "id-${local.app_gateway_name}-secrets"
  resource_group_name = azurerm_resource_group.security.name
  location            = azurerm_resource_group.security.location
}

resource "azurerm_user_assigned_identity" "app_gateway_controller" {
  count = local.app_gateway_enabled ? 1 : 0

  name                = "id-${local.app_gateway_name}-controller"
  resource_group_name = azurerm_resource_group.security.name
  location            = azurerm_resource_group.security.location
}

resource "azurerm_role_assignment" "app_gateway_controller_app_gateway_contributor" {
  count = local.app_gateway_enabled ? 1 : 0

  scope                = azurerm_application_gateway.aks_ingress.0.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.app_gateway_controller.0.principal_id
}
resource "azurerm_role_assignment" "app_gateway_controller_app_gateway_rg_reader" {
  count = local.app_gateway_enabled ? 1 : 0

  scope                = local.existing_vnet_defined ? var.network_configuration.existing_vnet.id : azurerm_resource_group.network.0.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.app_gateway_controller.0.principal_id
}
resource "azurerm_role_assignment" "app_gateway_controller_app_gateway_secrets_managed_identity_operator" {
  count = local.app_gateway_enabled ? 1 : 0

  scope                = azurerm_user_assigned_identity.app_gateway_secrets.0.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.app_gateway_controller.0.principal_id
}
resource "azurerm_role_assignment" "cluster_control_plane_vnet_dns_zone_contributor" {
  count = local.private_cluster_defined ? 1 : 0

  scope                = local.existing_vnet_defined ? var.network_configuration.existing_vnet.id : azurerm_virtual_network.aks_vnet.0.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.cluster_control_plane.0.principal_id
}
resource "azurerm_role_assignment" "cluster_control_plane_private_zone_dns_zone_contributor" {
  count = local.private_cluster_defined ? 1 : 0

  scope                = var.aks_configuration.private_cluster.private_dns_zone_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.cluster_control_plane.0.principal_id
}
resource "azurerm_role_assignment" "oms_agent_monitoring_metrics_publisher" {
  count = can(var.aks_configuration.managed_addons.oms_agent_workspace_id) && (var.aks_configuration.managed_addons.oms_agent_workspace_id != null && var.aks_configuration.managed_addons.oms_agent_workspace_id != "") ? 1 : 0

  scope                = azurerm_kubernetes_cluster.k8s.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_kubernetes_cluster.k8s.oms_agent[0].oms_agent_identity[0].object_id
}