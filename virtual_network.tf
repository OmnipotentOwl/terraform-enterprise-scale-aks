resource "azurerm_virtual_network" "aks_vnet" {
  count               = local.existing_vnet_defined ? 0 : 1
  name                = "vnet-${local.workload_name_sanitized}-${local.environment_sanitized}-${local.region_name_sanitized}"
  location            = local.existing_vnet_defined ? null : azurerm_resource_group.network.0.location
  resource_group_name = local.existing_vnet_defined ? null : azurerm_resource_group.network.0.name
  address_space       = local.existing_vnet_defined ? null : var.network_configuration.vnet_configuration.vnet_address_space
  dns_servers         = local.existing_vnet_defined ? null : var.network_configuration.vnet_configuration.dns_servers
}
resource "azurerm_role_assignment" "aks_cluster_virtual_network_network_contributor" {
  scope                = local.existing_vnet_defined ? var.network_configuration.existing_vnet.id : azurerm_virtual_network.aks_vnet.0.id
  role_definition_name = "Network Contributor"
  principal_id         = local.private_cluster_defined ? azurerm_user_assigned_identity.cluster_control_plane.0.principal_id : azurerm_kubernetes_cluster.k8s.identity[0].principal_id
}

resource "azurerm_subnet" "app_gateway" {
  count = local.app_gateway_enabled ? 1 : 0

  name                 = "snet-app-gateway"
  resource_group_name  = local.existing_vnet_defined ? var.network_configuration.existing_vnet.resource_group_name : azurerm_virtual_network.aks_vnet.0.resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.network_configuration.existing_vnet.name : azurerm_virtual_network.aks_vnet.0.name
  address_prefixes     = local.app_gateway_enabled ? var.network_configuration.ingress_configuration.app_gateway_subnet_address_space : null

  service_endpoints = [
    "Microsoft.KeyVault"
  ]
}
resource "azurerm_subnet" "ingress_ilb" {
  count                = local.internal_loadbalancer_enabled ? 1 : 0
  name                 = "snet-cluster-ingressservices"
  resource_group_name  = local.existing_vnet_defined ? var.network_configuration.existing_vnet.resource_group_name : azurerm_virtual_network.aks_vnet.0.resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.network_configuration.existing_vnet.name : azurerm_virtual_network.aks_vnet.0.name
  address_prefixes     = local.internal_loadbalancer_enabled ? var.network_configuration.ingress_configuration.internal_loadbalancer_subnet_address_space : null
}
resource "azurerm_subnet" "aks_system_pool" {
  name                 = "snet-aks-nodepool-system"
  resource_group_name  = local.existing_vnet_defined ? var.network_configuration.existing_vnet.resource_group_name : azurerm_virtual_network.aks_vnet.0.resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.network_configuration.existing_vnet.name : azurerm_virtual_network.aks_vnet.0.name
  address_prefixes     = var.k8s_system_pool_configuration.subnet_cidr

  lifecycle {
    ignore_changes = [
      private_endpoint_network_policies_enabled,
      private_link_service_network_policies_enabled
    ]
  }
}
resource "azurerm_subnet" "aks_spot_pool" {
  for_each = local.spot_pool_configurations

  name                 = "snet-aks-nodepool-spot${each.key}"
  resource_group_name  = local.existing_vnet_defined ? var.network_configuration.existing_vnet.resource_group_name : azurerm_virtual_network.aks_vnet.0.resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.network_configuration.existing_vnet.name : azurerm_virtual_network.aks_vnet.0.name
  address_prefixes     = each.value.subnet_cidr
}
resource "azurerm_subnet" "aks_worker_pool" {
  for_each = local.worker_pool_configurations

  name                 = "snet-aks-nodepool-worker${each.key}"
  resource_group_name  = local.existing_vnet_defined ? var.network_configuration.existing_vnet.resource_group_name : azurerm_virtual_network.aks_vnet.0.resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.network_configuration.existing_vnet.name : azurerm_virtual_network.aks_vnet.0.name
  address_prefixes     = each.value.subnet_cidr
}

resource "azurerm_subnet_route_table_association" "hub_egress_aks_system_pool" {
  count = local.udr_routing_enabled ? 1 : 0

  subnet_id      = azurerm_subnet.aks_system_pool.id
  route_table_id = var.network_configuration.egress_configuration.udr_resource.id
}
resource "azurerm_subnet_route_table_association" "hub_egress_aks_spot_pool" {
  for_each = local.udr_routing_enabled ? local.spot_pool_configurations : {}

  subnet_id      = azurerm_subnet.aks_spot_pool[each.key].id
  route_table_id = var.network_configuration.egress_configuration.udr_resource.id
}
resource "azurerm_subnet_route_table_association" "hub_egress_aks_worker_pool" {
  for_each = local.udr_routing_enabled ? local.worker_pool_configurations : {}

  subnet_id      = azurerm_subnet.aks_worker_pool[each.key].id
  route_table_id = var.network_configuration.egress_configuration.udr_resource.id
}