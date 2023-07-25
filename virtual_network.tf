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
  scope                = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].id : azurerm_virtual_network.aks_vnet[0].id
  role_definition_name = "Network Contributor"
  principal_id         = local.use_user_assigned_managed_identity ? azurerm_user_assigned_identity.cluster_control_plane[0].principal_id : azurerm_kubernetes_cluster.k8s.identity[0].principal_id
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
  resource_group_name  = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].resource_group_name : azurerm_virtual_network.aks_vnet[0].resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].name : azurerm_virtual_network.aks_vnet[0].name
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
  resource_group_name  = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].resource_group_name : azurerm_virtual_network.aks_vnet[0].resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].name : azurerm_virtual_network.aks_vnet[0].name
  address_prefixes     = local.internal_loadbalancer_enabled ? var.network_configuration.ingress_configuration.internal_loadbalancer_subnet_address_space : null
}
resource "azurecaf_name" "azurerm_subnet_aks_api_server" {
  count         = try(var.aks_configuration.security_options.api_server_access_profile.subnet_cidr != null, false) ? 1 : 0
  name          = "aks-apiserver"
  resource_type = "azurerm_subnet"
  clean_input   = true
}
resource "azurerm_subnet" "aks_api_server" {
  count = try(var.aks_configuration.security_options.api_server_access_profile.subnet_cidr != null, false) ? 1 : 0

  name                 = azurecaf_name.azurerm_subnet_aks_api_server[0].result
  resource_group_name  = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].resource_group_name : azurerm_virtual_network.aks_vnet[0].resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].name : azurerm_virtual_network.aks_vnet[0].name
  address_prefixes     = [var.aks_configuration.security_options.api_server_access_profile.subnet_cidr]

  delegation {
    name = "aks-api-server"
    service_delegation {
      name    = "Microsoft.ContainerService/managedClusters"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  lifecycle {
    ignore_changes = [
      private_endpoint_network_policies_enabled,
      private_link_service_network_policies_enabled
    ]
  }
}
resource "azurecaf_name" "azurerm_subnet_aks_system_pool_nodes" {
  count         = var.k8s_system_pool_configuration.node_subnet_cidr != null ? 1 : 0
  name          = "aks-nodepool-system"
  resource_type = "azurerm_subnet"
  clean_input   = true
}
resource "azurerm_subnet" "aks_system_pool_nodes" {
  count = var.k8s_system_pool_configuration.node_subnet_cidr != null ? 1 : 0

  name                 = azurecaf_name.azurerm_subnet_aks_system_pool_nodes[0].result
  resource_group_name  = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].resource_group_name : azurerm_virtual_network.aks_vnet[0].resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].name : azurerm_virtual_network.aks_vnet[0].name
  address_prefixes     = var.k8s_system_pool_configuration.node_subnet_cidr

  lifecycle {
    ignore_changes = [
      private_endpoint_network_policies_enabled,
      private_link_service_network_policies_enabled
    ]
  }
}
resource "azurecaf_name" "azurerm_subnet_aks_system_pool_pods" {
  count         = var.k8s_system_pool_configuration.pod_subnet_cidr != null ? 1 : 0
  name          = "aks-podpool-system"
  resource_type = "azurerm_subnet"
  clean_input   = true
}
resource "azurerm_subnet" "aks_system_pool_pods" {
  count = var.k8s_system_pool_configuration.pod_subnet_cidr != null ? 1 : 0

  name                 = azurecaf_name.azurerm_subnet_aks_system_pool_pods[0].result
  resource_group_name  = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].resource_group_name : azurerm_virtual_network.aks_vnet[0].resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].name : azurerm_virtual_network.aks_vnet[0].name
  address_prefixes     = var.k8s_system_pool_configuration.pod_subnet_cidr

  lifecycle {
    ignore_changes = [
      private_endpoint_network_policies_enabled,
      private_link_service_network_policies_enabled
    ]
  }
}
resource "azurecaf_name" "azurerm_subnet_aks_spot_pool_nodes" {
  for_each = { for key, nodepool in local.spot_pool_configurations : key => nodepool if nodepool.node_subnet_cidr != null }

  name          = "aks-nodepool-spot"
  resource_type = "azurerm_subnet"
  suffixes      = [each.value.name]
  clean_input   = true
}
resource "azurerm_subnet" "aks_spot_pool_nodes" {
  for_each = { for key, nodepool in local.spot_pool_configurations : key => nodepool if nodepool.node_subnet_cidr != null }

  name                 = azurecaf_name.azurerm_subnet_aks_spot_pool_nodes[each.key].result
  resource_group_name  = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].resource_group_name : azurerm_virtual_network.aks_vnet[0].resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].name : azurerm_virtual_network.aks_vnet[0].name
  address_prefixes     = each.value.node_subnet_cidr
}
resource "azurecaf_name" "azurerm_subnet_aks_spot_pool_pods" {
  for_each = { for key, nodepool in local.spot_pool_configurations : key => nodepool if nodepool.pod_subnet_cidr != null }

  name          = "aks-podpool-spot"
  resource_type = "azurerm_subnet"
  suffixes      = [each.value.name]
  clean_input   = true
}
resource "azurerm_subnet" "aks_spot_pool_pods" {
  for_each = { for key, nodepool in local.spot_pool_configurations : key => nodepool if nodepool.pod_subnet_cidr != null }

  name                 = azurecaf_name.azurerm_subnet_aks_spot_pool_pods[each.key].result
  resource_group_name  = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].resource_group_name : azurerm_virtual_network.aks_vnet[0].resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].name : azurerm_virtual_network.aks_vnet[0].name
  address_prefixes     = each.value.pod_subnet_cidr
}
resource "azurecaf_name" "azurerm_subnet_aks_worker_pool_nodes" {
  for_each = { for key, nodepool in local.worker_pool_configurations : key => nodepool if nodepool.node_subnet_cidr != null }

  name          = "aks-nodepool-worker"
  resource_type = "azurerm_subnet"
  suffixes      = [each.value.name]
  clean_input   = true
}
resource "azurerm_subnet" "aks_worker_pool_nodes" {
  for_each = { for key, nodepool in local.worker_pool_configurations : key => nodepool if nodepool.node_subnet_cidr != null }

  name                 = azurecaf_name.azurerm_subnet_aks_worker_pool_nodes[each.key].result
  resource_group_name  = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].resource_group_name : azurerm_virtual_network.aks_vnet[0].resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].name : azurerm_virtual_network.aks_vnet[0].name
  address_prefixes     = each.value.node_subnet_cidr
}
resource "azurecaf_name" "azurerm_subnet_aks_worker_pool_pods" {
  for_each = { for key, nodepool in local.worker_pool_configurations : key => nodepool if nodepool.pod_subnet_cidr != null }

  name          = "aks-podpool-worker"
  resource_type = "azurerm_subnet"
  suffixes      = [each.value.name]
  clean_input   = true
}
resource "azurerm_subnet" "aks_worker_pool_pods" {
  for_each = { for key, nodepool in local.worker_pool_configurations : key => nodepool if nodepool.pod_subnet_cidr != null }

  name                 = azurecaf_name.azurerm_subnet_aks_worker_pool_pods[each.key].result
  resource_group_name  = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].resource_group_name : azurerm_virtual_network.aks_vnet[0].resource_group_name
  virtual_network_name = local.existing_vnet_defined ? var.vnets[var.network_configuration.vnet_key].name : azurerm_virtual_network.aks_vnet[0].name
  address_prefixes     = each.value.pod_subnet_cidr
}

resource "azurerm_subnet_route_table_association" "hub_egress_aks_system_pool_nodes" {
  count = local.udr_routing_enabled ? 1 : 0

  subnet_id      = var.k8s_system_pool_configuration.node_subnet_cidr != null ? azurerm_subnet.aks_system_pool_nodes[0].id : var.vnets[var.network_configuration.vnet_key].subnets[var.k8s_system_pool_configuration.node_subnet_key].id
  route_table_id = var.user_defined_routes[var.network_configuration.egress_configuration.udr_key].id
}
resource "azurerm_subnet_route_table_association" "hub_egress_aks_spot_pool_nodes" {
  for_each = local.udr_routing_enabled ? local.spot_pool_configurations : {}

  subnet_id      = each.value.node_subnet_cidr != null ? azurerm_subnet.aks_spot_pool_nodes[each.key].id : var.vnets[var.network_configuration.vnet_key].subnets[each.value.node_subnet_key].id
  route_table_id = var.user_defined_routes[var.network_configuration.egress_configuration.udr_key].id
}
resource "azurerm_subnet_route_table_association" "hub_egress_aks_worker_pool_noes" {
  for_each = local.udr_routing_enabled ? local.worker_pool_configurations : {}

  subnet_id      = each.value.node_subnet_cidr != null ? azurerm_subnet.aks_worker_pool_nodes[each.key].id : var.vnets[var.network_configuration.vnet_key].subnets[each.value.node_subnet_key].id
  route_table_id = var.user_defined_routes[var.network_configuration.egress_configuration.udr_key].id
}
