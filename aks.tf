resource "azurecaf_name" "azurerm_kubernetes_cluster_k8s" {
  name          = local.workload_name_sanitized
  resource_type = "azurerm_kubernetes_cluster"
  prefixes      = try(coalesce(try(var.naming_convention.cluster_name.prefixes, null), try(var.global_settings.prefixes, null)), null)
  suffixes      = try(coalesce(try(var.naming_convention.cluster_name.suffixes, null), try(var.global_settings.suffixes, null)), null)
  random_length = try(coalesce(try(var.naming_convention.cluster_name.random_length, null), try(var.global_settings.random_length, null)), null)
  passthrough   = try(coalesce(try(var.naming_convention.cluster_name.passthrough, null), try(var.global_settings.passthrough, null)), null)
  use_slug      = try(coalesce(try(var.naming_convention.cluster_name.use_slug, null), try(var.global_settings.use_slug, null)), null)
  clean_input   = true
}
resource "azurecaf_name" "default_node_pool" {
  name          = "systempool"
  resource_type = "aks_node_pool_linux"
  prefixes      = try(coalesce(try(var.naming_convention.default_node_pool.prefixes, null), try(var.global_settings.prefixes, null)), null)
  suffixes      = try(coalesce(try(var.naming_convention.default_node_pool.suffixes, null), try(var.global_settings.suffixes, null)), null)
  random_length = try(coalesce(try(var.naming_convention.default_node_pool.random_length, null), try(var.global_settings.random_length, null)), null)
  passthrough   = try(coalesce(try(var.naming_convention.default_node_pool.passthrough, null), try(var.global_settings.passthrough, null)), null)
  use_slug      = try(coalesce(try(var.naming_convention.default_node_pool.use_slug, null), try(var.global_settings.use_slug, null)), null)
  clean_input   = true
}
resource "azurecaf_name" "default_node_pool_temporary_name_for_rotation" {
  name          = "temp"
  resource_type = "aks_node_pool_linux"
  random_length = 4
  use_slug      = false
  clean_input   = true
}

#tfsec:ignore:azure-container-logging
resource "azurerm_kubernetes_cluster" "k8s" {
  name                                = azurecaf_name.azurerm_kubernetes_cluster_k8s.result
  location                            = azurerm_resource_group.cluster.location
  resource_group_name                 = azurerm_resource_group.cluster.name
  sku_tier                            = var.aks_configuration.sku_tier
  dns_prefix                          = local.private_cluster_enabled ? null : local.aks_dns_name_prefix
  dns_prefix_private_cluster          = local.private_cluster_enabled ? local.aks_dns_name_prefix : null
  private_cluster_enabled             = local.private_cluster_enabled
  private_dns_zone_id                 = try(var.aks_configuration.private_cluster.private_dns_zone_id, null)
  private_cluster_public_fqdn_enabled = local.private_cluster_enabled ? var.aks_configuration.private_cluster.enable_public_fqdn : null
  automatic_channel_upgrade           = var.aks_configuration.automatic_upgrade_channel
  disk_encryption_set_id              = local.customer_managed_keys_enabled ? azurerm_disk_encryption_set.aks_customer_managed_key[0].id : null
  node_os_channel_upgrade             = var.aks_configuration.node_os_upgrade_channel
  node_resource_group                 = "MC_${substr(azurerm_resource_group.cluster.name, 0, 15)}_${azurecaf_name.azurerm_kubernetes_cluster_k8s.result}"

  azure_policy_enabled      = true
  open_service_mesh_enabled = var.aks_configuration.managed_addons.open_service_mesh
  oidc_issuer_enabled       = var.aks_configuration.managed_addons.oidc_issuer
  workload_identity_enabled = var.aks_configuration.managed_addons.oidc_issuer
  image_cleaner_enabled     = var.aks_configuration.managed_addons.image_cleaner

  role_based_access_control_enabled = true
  run_command_enabled               = var.aks_configuration.security_options.run_command_enabled

  default_node_pool {
    name                         = azurecaf_name.default_node_pool.result
    type                         = "VirtualMachineScaleSets"
    temporary_name_for_rotation  = azurecaf_name.default_node_pool_temporary_name_for_rotation.result
    vm_size                      = var.k8s_system_pool_configuration.pool_sku
    enable_auto_scaling          = true
    enable_host_encryption       = var.aks_configuration.security_options.enable_host_encryption
    max_pods                     = var.k8s_system_pool_configuration.max_pods_per_node
    min_count                    = var.k8s_system_pool_configuration.pool_min_size
    max_count                    = var.k8s_system_pool_configuration.pool_max_size
    node_labels                  = var.k8s_system_pool_configuration.k8s_labels
    node_taints                  = var.k8s_system_pool_configuration.k8s_taints
    only_critical_addons_enabled = true
    os_disk_size_gb              = var.k8s_system_pool_configuration.os_disk_size_gb
    os_disk_type                 = "Ephemeral"
    os_sku                       = var.k8s_system_pool_configuration.os_sku
    vnet_subnet_id               = var.k8s_system_pool_configuration.node_subnet_key != null ? var.vnets[var.network_configuration.vnet_key].subnets[var.k8s_system_pool_configuration.node_subnet_key].id : azurerm_subnet.aks_system_pool_nodes[0].id
    pod_subnet_id                = var.k8s_system_pool_configuration.pod_subnet_key != null ? var.vnets[var.network_configuration.vnet_key].subnets[var.k8s_system_pool_configuration.pod_subnet_key].id : var.k8s_system_pool_configuration.pod_subnet_cidr != null ? azurerm_subnet.aks_system_pool_pods[0].id : null
    zones                        = var.k8s_system_pool_configuration.availability_zones

    dynamic "upgrade_settings" {
      for_each = try(var.k8s_system_pool_configuration.upgrade_settings, null) != null ? [try(var.k8s_system_pool_configuration.upgrade_settings, null)] : []
      content {
        max_surge = upgrade_settings.value.max_surge
      }
    }
  }

  dynamic "api_server_access_profile" {
    for_each = try(var.aks_configuration.security_options.api_server_access_profile, null) != null ? [try(var.aks_configuration.security_options.api_server_access_profile, null)] : []
    content {
      authorized_ip_ranges     = api_server_access_profile.value.authorized_ip_ranges
      subnet_id                = api_server_access_profile.value.subnet_key != null ? var.vnets[var.network_configuration.vnet_key].subnets[api_server_access_profile.value.subnet_key].id : api_server_access_profile.value.subnet_cidr != null ? azurerm_subnet.aks_api_server[0].id : null
      vnet_integration_enabled = api_server_access_profile.value.vnet_integration_enabled
    }
  }

  identity {
    type         = local.use_user_assigned_managed_identity ? "UserAssigned" : "SystemAssigned"
    identity_ids = local.use_user_assigned_managed_identity ? [azurerm_user_assigned_identity.cluster_control_plane[0].id] : null
  }

  auto_scaler_profile {
    balance_similar_node_groups = true
    expander                    = "least-waste"
  }

  maintenance_window {
    allowed {
      day   = "Sunday"
      hours = [0, 1, 2, 3, 4]
    }
  }

  network_profile {
    ip_versions         = var.network_configuration.ip_versions
    load_balancer_sku   = "standard"
    network_plugin      = var.network_configuration.cluster_configuration.network_plugin
    network_policy      = var.network_configuration.cluster_configuration.network_policy
    network_plugin_mode = var.network_configuration.cluster_configuration.network_plugin_mode
    ebpf_data_plane     = var.network_configuration.cluster_configuration.ebpf_data_plane
    outbound_type       = can(var.network_configuration.egress_configuration.egress_type) ? var.network_configuration.egress_configuration.egress_type : "loadBalancer"
  }

  azure_active_directory_role_based_access_control {
    managed            = true
    tenant_id          = data.azurerm_subscription.current.tenant_id
    azure_rbac_enabled = true
  }


  workload_autoscaler_profile {
    keda_enabled                    = var.aks_configuration.managed_addons.keda
    vertical_pod_autoscaler_enabled = var.aks_configuration.managed_addons.vertical_pod_autoscaler
  }

  dynamic "storage_profile" {
    for_each = try(var.aks_configuration.storage_profile[*], {})
    content {
      blob_driver_enabled         = storage_profile.value.blob_driver_enabled
      disk_driver_enabled         = storage_profile.value.disk_driver_enabled
      disk_driver_version         = storage_profile.value.disk_driver_version
      file_driver_enabled         = storage_profile.value.file_driver_enabled
      snapshot_controller_enabled = storage_profile.value.snapshot_controller_enabled
    }
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  dynamic "oms_agent" {
    for_each = try(var.aks_configuration.container_insights[*], {})
    content {
      log_analytics_workspace_id      = can(oms_agent.value.log_analytics_workspace_id) && (oms_agent.value.log_analytics_workspace_id != null && oms_agent.value.log_analytics_workspace_id != "") ? oms_agent.value.log_analytics_workspace_id : var.aks_configuration.log_analytics_workspace_id
      msi_auth_for_monitoring_enabled = oms_agent.value.msi_auth_for_monitoring_enabled
    }
  }

  dynamic "microsoft_defender" {
    for_each = try(var.aks_configuration.microsoft_defender[*], {})
    content {
      log_analytics_workspace_id = microsoft_defender.value.log_analytics_workspace_id
    }
  }

  dynamic "service_mesh_profile" {
    for_each = try(var.aks_configuration.service_mesh_profile[*], {})
    content {
      mode                             = service_mesh_profile.value.mode
      internal_ingress_gateway_enabled = service_mesh_profile.value.internal_ingress_gateway_enabled
      external_ingress_gateway_enabled = service_mesh_profile.value.external_ingress_gateway_enabled
    }
  }

  lifecycle {
    ignore_changes = [
      identity[0].identity_ids,
      default_node_pool[0].node_count,
      default_node_pool[0].node_taints,
      default_node_pool[0].tags,
      microsoft_defender,
      tags
    ]
  }
}
resource "azurecaf_name" "azurerm_kubernetes_cluster_node_pool_spot_pool" {
  for_each = local.spot_pool_configurations

  name          = "spot${each.value.name}"
  resource_type = "aks_node_pool_linux"
  prefixes      = try(coalesce(each.value.naming_conventions_override.prefixes, var.global_settings.prefixes), null)
  suffixes      = try(coalesce(each.value.naming_conventions_override.suffixes, var.global_settings.suffixes), null)
  random_length = try(coalesce(each.value.naming_conventions_override.random_length, var.global_settings.random_length), null)
  passthrough   = try(coalesce(each.value.naming_conventions_override.passthrough, var.global_settings.passthrough), null)
  clean_input   = true
}
resource "azurerm_kubernetes_cluster_node_pool" "spot_pool" {
  for_each = local.spot_pool_configurations

  name                  = azurecaf_name.azurerm_kubernetes_cluster_node_pool_spot_pool[each.key].result
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  mode                  = "User"
  priority              = "Spot"
  eviction_policy       = "Delete"
  vm_size               = each.value.pool_sku
  os_disk_size_gb       = each.value.os_disk_size_gb
  os_sku                = each.value.os_sku
  os_type               = each.value.os_type
  os_disk_type          = "Ephemeral"
  max_pods              = each.value.max_pods_per_node
  spot_max_price        = each.value.spot_max_price
  node_labels = merge({
    "kubernetes.azure.com/scalesetpriority" = "spot"
  }, each.value.k8s_labels)
  node_taints = concat([
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  ], each.value.k8s_taints)
  min_count              = each.value.pool_min_size
  max_count              = each.value.pool_max_size
  enable_auto_scaling    = true
  vnet_subnet_id         = each.value.node_subnet_key != null ? var.vnets[var.network_configuration.vnet_key].subnets[each.value.node_subnet_key].id : azurerm_subnet.aks_spot_pool_nodes[each.key].id
  pod_subnet_id          = each.value.pod_subnet_key != null ? var.vnets[var.network_configuration.vnet_key].subnets[each.value.pod_subnet_key].id : each.value.pod_subnet_cidr != null ? azurerm_subnet.aks_spot_pool_pods[each.key].id : null
  enable_host_encryption = var.aks_configuration.security_options.enable_host_encryption
  zones                  = each.value.availability_zones

  dynamic "upgrade_settings" {
    for_each = try(each.value.upgrade_settings, null) != null ? [try(each.value.upgrade_settings, null)] : []
    content {
      max_surge = upgrade_settings.value.max_surge
    }
  }

  lifecycle {
    ignore_changes = [
      node_count,
      tags
    ]
  }
}
resource "azurecaf_name" "azurerm_kubernetes_cluster_node_pool_worker_pool" {
  for_each = local.worker_pool_configurations

  name          = "work${each.value.name}"
  resource_type = "aks_node_pool_linux"
  prefixes      = try(coalesce(each.value.naming_conventions_override.prefixes, var.global_settings.prefixes), null)
  suffixes      = try(coalesce(each.value.naming_conventions_override.suffixes, var.global_settings.suffixes), null)
  random_length = try(coalesce(each.value.naming_conventions_override.random_length, var.global_settings.random_length), null)
  passthrough   = try(coalesce(each.value.naming_conventions_override.passthrough, var.global_settings.passthrough), null)
  clean_input   = true
}
resource "azurerm_kubernetes_cluster_node_pool" "worker_pool" {
  for_each = local.worker_pool_configurations

  name                   = azurecaf_name.azurerm_kubernetes_cluster_node_pool_worker_pool[each.key].result
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.k8s.id
  mode                   = "User"
  vm_size                = each.value.pool_sku
  os_disk_size_gb        = each.value.os_disk_size_gb
  os_sku                 = each.value.os_sku
  os_type                = each.value.os_type
  os_disk_type           = "Ephemeral"
  max_pods               = each.value.max_pods_per_node
  node_labels            = merge({}, each.value.k8s_labels)
  node_taints            = concat([], each.value.k8s_taints)
  min_count              = each.value.pool_min_size
  max_count              = each.value.pool_max_size
  enable_auto_scaling    = true
  vnet_subnet_id         = each.value.node_subnet_key != null ? var.vnets[var.network_configuration.vnet_key].subnets[each.value.node_subnet_key].id : azurerm_subnet.aks_worker_pool_nodes[each.key].id
  pod_subnet_id          = each.value.pod_subnet_key != null ? var.vnets[var.network_configuration.vnet_key].subnets[each.value.pod_subnet_key].id : each.value.pod_subnet_cidr != null ? azurerm_subnet.aks_worker_pool_pods[each.key].id : null
  enable_host_encryption = var.aks_configuration.security_options.enable_host_encryption
  zones                  = each.value.availability_zones
  workload_runtime       = each.value.workload_runtime

  dynamic "upgrade_settings" {
    for_each = try(each.value.upgrade_settings, null) != null ? [try(each.value.upgrade_settings, null)] : []
    content {
      max_surge = upgrade_settings.value.max_surge
    }
  }

  lifecycle {
    ignore_changes = [
      node_count,
      tags
    ]
  }
}
resource "azurecaf_name" "azurerm_disk_encryption_set_aks_customer_managed_key" {
  count = local.customer_managed_keys_enabled ? 1 : 0

  name          = azurecaf_name.azurerm_kubernetes_cluster_k8s.result
  resource_type = "azurerm_disk_encryption_set"
  clean_input   = true
}
resource "azurerm_disk_encryption_set" "aks_customer_managed_key" {
  count = local.customer_managed_keys_enabled ? 1 : 0

  name                      = azurecaf_name.azurerm_disk_encryption_set_aks_customer_managed_key[0].result
  resource_group_name       = azurerm_key_vault.aks_customer_managed_keys_encryption[0].resource_group_name
  location                  = azurerm_key_vault.aks_customer_managed_keys_encryption[0].location
  key_vault_key_id          = azurerm_key_vault_key.aks_customer_managed_keys_encryption[0].id
  auto_key_rotation_enabled = true
  encryption_type           = "EncryptionAtRestWithCustomerKey"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "aks_kublet_node_rg_virtual_machine_contributor" {
  scope                = "${data.azurerm_subscription.current.id}/resourceGroups/${azurerm_kubernetes_cluster.k8s.node_resource_group}"
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id

  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]
}
