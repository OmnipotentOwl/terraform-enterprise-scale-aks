resource "azurecaf_name" "azurerm_kubernetes_cluster_k8s" {
  name          = local.workload_name_sanitized
  resource_type = "azurerm_kubernetes_cluster"
  prefixes      = var.global_settings.prefixes
  suffixes      = var.global_settings.suffixes
  random_length = var.global_settings.random_length
  passthrough   = var.global_settings.passthrough
  clean_input   = true
}
#tfsec:ignore:azure-container-logging
resource "azurerm_kubernetes_cluster" "k8s" {
  name                                = azurecaf_name.azurerm_kubernetes_cluster_k8s.result
  location                            = azurerm_resource_group.cluster.location
  resource_group_name                 = azurerm_resource_group.cluster.name
  sku_tier                            = var.aks_update_maintenance_configuration.aks_uptime_sku
  dns_prefix                          = local.private_cluster_defined ? null : local.aks_dns_name_prefix
  dns_prefix_private_cluster          = local.private_cluster_defined ? local.aks_dns_name_prefix : null
  private_cluster_enabled             = local.private_cluster_defined
  private_dns_zone_id                 = local.private_cluster_defined ? var.aks_configuration.private_cluster.private_dns_zone_id : null
  private_cluster_public_fqdn_enabled = local.private_cluster_defined ? var.aks_configuration.private_cluster.enable_public_fqdn : null
  automatic_channel_upgrade           = var.aks_update_maintenance_configuration.automatic_channel_upgrade
  disk_encryption_set_id              = local.customer_managed_keys_enabled ? azurerm_disk_encryption_set.aks_customer_managed_key[0].id : null
  node_resource_group                 = "MC_${substr(azurerm_resource_group.cluster.name, 0, 15)}_${azurecaf_name.azurerm_kubernetes_cluster_k8s.result}"

  default_node_pool {
    name                         = "systempool"
    type                         = "VirtualMachineScaleSets"
    vm_size                      = var.k8s_system_pool_configuration.pool_sku
    min_count                    = var.k8s_system_pool_configuration.pool_min_size
    max_count                    = var.k8s_system_pool_configuration.pool_max_size
    os_disk_size_gb              = var.k8s_system_pool_configuration.os_disk_size_gb
    os_disk_type                 = "Ephemeral"
    max_pods                     = var.k8s_system_pool_configuration.max_pods_per_node
    enable_auto_scaling          = true
    only_critical_addons_enabled = true
    vnet_subnet_id               = azurerm_subnet.aks_system_pool.id
    enable_host_encryption       = var.aks_configuration.security_options.enable_host_encryption
    zones                        = var.k8s_system_pool_configuration.availability_zones
  }

  identity {
    type         = local.private_cluster_defined ? "UserAssigned" : "SystemAssigned"
    identity_ids = local.private_cluster_defined ? [azurerm_user_assigned_identity.cluster_control_plane[0].id] : null
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
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = can(var.network_configuration.egress_configuration.egress_type) ? var.network_configuration.egress_configuration.egress_type : "loadBalancer"
  }

  role_based_access_control_enabled = true
  azure_active_directory_role_based_access_control {
    managed            = true
    tenant_id          = data.azurerm_subscription.current.tenant_id
    azure_rbac_enabled = true
  }

  azure_policy_enabled      = true
  open_service_mesh_enabled = var.aks_configuration.managed_addons.open_service_mesh
  oidc_issuer_enabled       = var.aks_configuration.managed_addons.oidc_issuer
  workload_identity_enabled = var.aks_configuration.managed_addons.oidc_issuer
  image_cleaner_enabled     = var.aks_configuration.managed_addons.image_cleaner

  workload_autoscaler_profile {
    keda_enabled = var.aks_configuration.managed_addons.keda
  }

  storage_profile {
    blob_driver_enabled         = var.aks_configuration.storage_profile_configuration.blob_driver_enabled
    disk_driver_enabled         = true
    disk_driver_version         = var.aks_configuration.storage_profile_configuration.disk_driver_version
    file_driver_enabled         = true
    snapshot_controller_enabled = true
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  dynamic "oms_agent" {
    for_each = can(var.aks_configuration.managed_addons.oms_agent_workspace_id) && (var.aks_configuration.managed_addons.oms_agent_workspace_id != null && var.aks_configuration.managed_addons.oms_agent_workspace_id != "") ? [1] : []
    content {
      log_analytics_workspace_id = var.aks_configuration.managed_addons.oms_agent_workspace_id
    }
  }

  dynamic "microsoft_defender" {
    for_each = can(var.aks_configuration.managed_addons.defender_workspace_id) && (var.aks_configuration.managed_addons.defender_workspace_id != null && var.aks_configuration.managed_addons.defender_workspace_id != "") ? [1] : []
    content {
      log_analytics_workspace_id = var.aks_configuration.managed_addons.defender_workspace_id
    }
  }

  lifecycle {
    ignore_changes = [
      identity[0].identity_ids,
      default_node_pool[0].node_count,
      default_node_pool[0].node_taints,
      default_node_pool[0].tags,
      oms_agent,
      microsoft_defender,
      tags
    ]
  }
}
resource "azurecaf_name" "azurerm_kubernetes_cluster_node_pool_spot_pool" {
  for_each = local.spot_pool_configurations

  name          = "spotpool${each.value.name}"
  resource_type = "general_safe"
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
  vnet_subnet_id         = azurerm_subnet.aks_spot_pool[each.key].id
  enable_host_encryption = var.aks_configuration.security_options.enable_host_encryption
  zones                  = each.value.availability_zones

  lifecycle {
    ignore_changes = [
      node_count,
      tags
    ]
  }
}
resource "azurecaf_name" "azurerm_kubernetes_cluster_node_pool_worker_pool" {
  for_each = local.worker_pool_configurations

  name          = "workerpool${each.value.name}"
  resource_type = "general_safe"
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
  os_disk_type           = "Ephemeral"
  max_pods               = each.value.max_pods_per_node
  node_labels            = merge({}, each.value.k8s_labels)
  node_taints            = concat([], each.value.k8s_taints)
  min_count              = each.value.pool_min_size
  max_count              = each.value.pool_max_size
  enable_auto_scaling    = true
  vnet_subnet_id         = azurerm_subnet.aks_worker_pool[each.key].id
  enable_host_encryption = var.aks_configuration.security_options.enable_host_encryption
  zones                  = each.value.availability_zones

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
resource "azurerm_role_assignment" "aks_kublet_node_rg_managed_identity_operator" {
  scope                = "${data.azurerm_subscription.current.id}/resourceGroups/${azurerm_kubernetes_cluster.k8s.node_resource_group}"
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}
resource "azurerm_role_assignment" "aks_kublet_security_rg_managed_identity_operator" {
  scope                = azurerm_resource_group.security.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}
module "private_storage_class" {
  count  = local.use_built_in_storage_class ? 1 : 0
  source = "./modules/azure-private-storage-class"

  cluster_name            = azurerm_kubernetes_cluster.k8s.name
  zonal_replication       = can(var.aks_configuration.private_cluster.private_storage.enable_zonal_replication) ? var.aks_configuration.private_cluster.private_storage.enable_zonal_replication : false
  private_endpoint_subnet = var.aks_configuration.private_cluster.private_endpoint_subnet
  storage_resource_group = {
    id       = "${data.azurerm_subscription.current.id}/resourceGroups/${azurerm_kubernetes_cluster.k8s.node_resource_group}"
    name     = azurerm_kubernetes_cluster.k8s.node_resource_group
    location = azurerm_kubernetes_cluster.k8s.location
  }

  depends_on = [
    azurerm_kubernetes_cluster.k8s,
    azurerm_kubernetes_cluster_node_pool.worker_pool,
  ]
}
