resource "azurecaf_name" "azurerm_virtual_network_aks_vnet" {
  count = local.existing_vnet_defined ? 0 : 1

  name          = local.workload_name_sanitized
  resource_type = "azurerm_virtual_network"
  prefixes      = var.global_settings.prefixes
  suffixes      = var.global_settings.suffixes
  random_length = var.global_settings.random_length
  passthrough   = var.global_settings.passthrough
  clean_input   = true
}
resource "azurerm_virtual_network" "aks_vnet" {
  count = local.existing_vnet_defined ? 0 : 1

  name                = azurecaf_name.azurerm_virtual_network_aks_vnet[0].result
  location            = local.existing_vnet_defined ? null : azurerm_resource_group.network[0].location
  resource_group_name = local.existing_vnet_defined ? null : azurerm_resource_group.network[0].name
  address_space       = local.existing_vnet_defined ? null : var.network_configuration.vnet_configuration.vnet_address_space
  dns_servers         = local.existing_vnet_defined ? null : var.network_configuration.vnet_configuration.dns_servers
}
resource "azurerm_role_assignment" "aks_cluster_virtual_network_network_contributor" {
  scope                = local.existing_vnet_defined ? var.network_configuration.existing_vnet.id : azurerm_virtual_network.aks_vnet[0].id
  role_definition_name = "Network Contributor"
  principal_id         = local.private_cluster_defined ? azurerm_user_assigned_identity.cluster_control_plane[0].principal_id : azurerm_kubernetes_cluster.k8s.identity[0].principal_id
}
resource "azurecaf_name" "azurerm_subnet_app_gateway" {
  count = local.app_gateway_enabled ? 1 : 0

  name          = "app-gateway"
  resource_type = "azurerm_subnet"
  clean_input   = true
}
resource "azurerm_subnet" "app_gateway" {
  count = local.app_gateway_enabled ? 1 : 0

  name                 = azurecaf_name.azurerm_subnet_app_gateway[0].result
  resource_group_name  = local.existing_vnet_defined ? var.network_configuration.existing_vnet.resource_group_name : azurerm_virtual_network.aks_vnet[0].resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.network_configuration.existing_vnet.name : azurerm_virtual_network.aks_vnet[0].name
  address_prefixes     = local.app_gateway_enabled ? var.network_configuration.ingress_configuration.app_gateway_subnet_address_space : null

  service_endpoints = [
    "Microsoft.KeyVault"
  ]
}
resource "azurecaf_name" "azurerm_subnet_ingress_ilb" {
  count = local.internal_loadbalancer_enabled ? 1 : 0

  name          = "cluster-ingressservices"
  resource_type = "azurerm_subnet"
  clean_input   = true
}
resource "azurerm_subnet" "ingress_ilb" {
  count = local.internal_loadbalancer_enabled ? 1 : 0

  name                 = azurecaf_name.azurerm_subnet_ingress_ilb[0].result
  resource_group_name  = local.existing_vnet_defined ? var.network_configuration.existing_vnet.resource_group_name : azurerm_virtual_network.aks_vnet[0].resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.network_configuration.existing_vnet.name : azurerm_virtual_network.aks_vnet[0].name
  address_prefixes     = local.internal_loadbalancer_enabled ? var.network_configuration.ingress_configuration.internal_loadbalancer_subnet_address_space : null
}
resource "azurecaf_name" "azurerm_subnet_aks_system_pool" {
  name          = "aks-nodepool-system"
  resource_type = "azurerm_subnet"
  clean_input   = true
}
resource "azurerm_subnet" "aks_system_pool" {
  name                 = azurecaf_name.azurerm_subnet_aks_system_pool.result
  resource_group_name  = local.existing_vnet_defined ? var.network_configuration.existing_vnet.resource_group_name : azurerm_virtual_network.aks_vnet[0].resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.network_configuration.existing_vnet.name : azurerm_virtual_network.aks_vnet[0].name
  address_prefixes     = var.k8s_system_pool_configuration.subnet_cidr

  lifecycle {
    ignore_changes = [
      private_endpoint_network_policies_enabled,
      private_link_service_network_policies_enabled
    ]
  }
}
resource "azurecaf_name" "azurerm_subnet_aks_spot_pool" {
  for_each = local.spot_pool_configurations

  name          = "aks-nodepool-spot"
  resource_type = "azurerm_subnet"
  suffixes      = [each.key]
  clean_input   = true
}
resource "azurerm_subnet" "aks_spot_pool" {
  for_each = local.spot_pool_configurations

  name                 = azurecaf_name.azurerm_subnet_aks_spot_pool[each.key].result
  resource_group_name  = local.existing_vnet_defined ? var.network_configuration.existing_vnet.resource_group_name : azurerm_virtual_network.aks_vnet[0].resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.network_configuration.existing_vnet.name : azurerm_virtual_network.aks_vnet[0].name
  address_prefixes     = each.value.subnet_cidr
}
resource "azurecaf_name" "azurerm_subnet_aks_worker_pool" {
  for_each = local.worker_pool_configurations

  name          = "aks-nodepool-worker"
  resource_type = "azurerm_subnet"
  suffixes      = [each.key]
  clean_input   = true
}
resource "azurerm_subnet" "aks_worker_pool" {
  for_each = local.worker_pool_configurations

  name                 = azurecaf_name.azurerm_subnet_aks_worker_pool[each.key].result
  resource_group_name  = local.existing_vnet_defined ? var.network_configuration.existing_vnet.resource_group_name : azurerm_virtual_network.aks_vnet[0].resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.network_configuration.existing_vnet.name : azurerm_virtual_network.aks_vnet[0].name
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
