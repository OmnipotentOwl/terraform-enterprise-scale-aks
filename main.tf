locals {
  workload_name_sanitized = lower(var.workload_name)
  region_name_sanitized   = lower(var.region_name)

  aks_dns_name_prefix           = "${azurecaf_name.azurerm_kubernetes_cluster_k8s.result}-dns"
  private_cluster_defined       = can(var.aks_configuration.private_cluster.private_dns_zone_id)
  customer_managed_keys_enabled = can(var.aks_configuration.security_options.enable_self_managed_keys) ? var.aks_configuration.security_options.enable_self_managed_keys : false
  existing_vnet_defined         = can(var.network_configuration.vnet_configuration.vnet_address_space) ? false : true
  udr_routing_enabled           = can(var.network_configuration.egress_configuration.egress_type) ? var.network_configuration.egress_configuration.egress_type == "userDefinedRouting" : false
  app_gateway_enabled           = can(var.network_configuration.ingress_configuration.app_gateway.subnet_address_space) ? true : false
  internal_loadbalancer_enabled = can(var.network_configuration.ingress_configuration.internal_loadbalancer_enabled) ? var.network_configuration.ingress_configuration.internal_loadbalancer_enabled : false
  use_built_in_storage_class    = can(var.aks_configuration.private_cluster.private_storage.enable_built_in_storage_class) ? var.aks_configuration.private_cluster.private_storage.enable_built_in_storage_class : false

  spot_pool_configurations   = { for k, v in var.k8s_spot_pool_configurations : k => v }
  worker_pool_configurations = { for k, v in var.k8s_worker_pool_configurations : k => v }
}

data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}
