<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-enterprise-scale-aks
Terraform Module for deploying an AKS cluster following Microsoft's Cloud Adoption Framework

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.3.0)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (>= 0.6.0)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (>= 2.5.0)

- <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) (>= 1.2.23)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.65.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.0.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) (>= 1.2.23)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.65.0)

## Modules

The following Modules are called:

### <a name="module_managed_prometheus"></a> [managed\_prometheus](#module\_managed\_prometheus)

Source: ./modules/aks-managed-prometheus

Version:

## Required Inputs

The following input variables are required:

### <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings)

Description: (required) global settings for the workload

Type:

```hcl
object({
    prefixes      = optional(list(string), null)
    suffixes      = optional(list(string), null)
    random_length = optional(number, null)
    passthrough   = optional(bool, null)
  })
```

### <a name="input_network_configuration"></a> [network\_configuration](#input\_network\_configuration)

Description: (required) network configuration for the AKS cluster

Type:

```hcl
object({
    vnet_key = optional(string, null)
    vnet_configuration = optional(object({
      vnet_address_space = list(string)
      dns_servers        = optional(list(string), null)
    }), null)
    ip_versions = optional(list(string), null) # ["IPv4", "IPv6"] requires subscription Feature Registration "Microsoft.ContainerService/AKS-EnableDualStack".
    ingress_configuration = object({
      app_gateway = optional(object({
        sku                  = string
        min_size             = optional(number, 0)
        max_size             = optional(number, 10)
        subnet_address_space = list(string)
        availability_zones   = list(string)
      }))
      internal_loadbalancer_enabled              = bool
      internal_loadbalancer_subnet_address_space = optional(list(string), null)
    })
    cluster_configuration = optional(object({
      network_plugin      = optional(string, "azure")
      network_policy      = optional(string, "azure")
      network_plugin_mode = optional(string, null) # required subscription Feature Registration "Microsoft.ContainerService/AzureOverlayPreview"
      pod_cidr            = optional(string, null) # when network_plugin is set to "azure" and network_plugin_mode is set to "Overlay" pod_cidr can be specified
      ebpf_data_plane     = optional(string, null) # when ebpf_data_plane is set to "cilium" network_plugin must be set to "azure"
      }), {
      network_plugin = "azure"
      network_policy = "azure"
    })
    egress_configuration = optional(object({
      egress_type = optional(string, "loadBalancer") # loadBalancer | userDefinedRouting | managedNATGateway | userAssignedNATGateway
      udr_key     = optional(string, null)
    }))
  })
```

### <a name="input_region_name"></a> [region\_name](#input\_region\_name)

Description: (required) region name to provision resources into

Type: `string`

### <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name)

Description: (required) workload name to seed into globaly unique names for resources

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_aks_configuration"></a> [aks\_configuration](#input\_aks\_configuration)

Description: AKS configuration options for cluster provisioning

Type:

```hcl
object({
    sku_tier                  = optional(string, "Free")
    automatic_upgrade_channel = optional(string, "stable")
    node_os_upgrade_channel   = optional(string, null) # required subscription Feature Registration "Microsoft.ContainerService/NodeOsUpgradeChannelPreview" # "None" | "Unmanaged" | "SecurityPatch" | "NodeImage"
    private_cluster = optional(object({
      enabled              = optional(bool, false)
      private_dns_zone_id  = optional(string, null)
      private_dns_zone_key = optional(string, null)
      enable_public_fqdn   = optional(bool, false)
      private_endpoint_subnet = optional(object({
        id                  = string
        name                = string
        resource_group_name = string
      }), null)
    }), null)
    managed_addons = object({
      open_service_mesh       = optional(bool, false)
      oidc_issuer             = optional(bool, false)
      keda                    = optional(bool, false)
      image_cleaner           = optional(bool, false)
      vertical_pod_autoscaler = optional(bool, false)
    })
    container_registries = optional(map(object({
      key    = optional(string, null)
      lz_key = optional(string, null)
      id     = optional(string, null)
    })), {})
    container_insights = optional(object({
      log_analytics_workspace_id                   = optional(string, null)
      msi_auth_for_monitoring_enabled              = optional(bool, false)
      streams                                      = optional(list(string), ["Microsoft-ContainerLog", "Microsoft-ContainerLogV2", "Microsoft-KubeEvents", "Microsoft-KubePodInventory", "Microsoft-KubeNodeInventory", "Microsoft-KubePVInventory", "Microsoft-KubeServices", "Microsoft-KubeMonAgentEvents", "Microsoft-InsightsMetrics", "Microsoft-ContainerInventory", "Microsoft-ContainerNodeInventory", "Microsoft-Perf"])
      data_collection_interval                     = optional(string, "1m")
      namespace_filtering_mode_for_data_collection = optional(string, "Off")
      namespaces_for_data_collection               = optional(list(string), ["kube-system", "gatekeeper-system", "azure-arc"])
      enable_syslog                                = optional(bool, false)
      syslog_facilities                            = optional(list(string), ["auth", "authpriv", "cron", "daemon", "mark", "kern", "local0", "local1", "local2", "local3", "local4", "local5", "local6", "local7", "lpr", "mail", "news", "syslog", "user", "uucp"])
      syslog_levels                                = optional(list(string), ["Debug", "Info", "Notice", "Warning", "Error", "Critical", "Alert", "Emergency"])
    }), null)
    managed_prometheus = optional(object({
      azure_monitor_workspace_id       = optional(string, null)
      azure_monitor_workspace_location = optional(string, null)
      metric_annotations_allowlist     = optional(string, null)
      metric_labels_allowlist          = optional(string, null)
    }), null)
    microsoft_defender = optional(object({
      log_analytics_workspace_id = optional(string, null)
      log_analytics_key          = optional(string, null)
    }), null)
    storage_profile = optional(object({
      blob_driver_enabled         = optional(bool, true)
      file_driver_enabled         = optional(bool, true)
      disk_driver_enabled         = optional(bool, true)
      disk_driver_version         = optional(string, "v1")
      snapshot_controller_enabled = optional(bool, true)
      }), {
      blob_driver_enabled         = true
      file_driver_enabled         = true
      disk_driver_enabled         = true
      disk_driver_version         = "v1"
      snapshot_controller_enabled = true
    })
    security_options = object({
      enable_host_encryption      = bool
      enable_self_managed_keys    = bool
      security_resource_group_key = optional(string, null)
      run_command_enabled         = optional(bool, null)
      api_server_access_profile = optional(object({
        authorized_ip_ranges     = optional(list(string), null)
        subnet_cidr              = optional(string, null)
        subnet_key               = optional(string, null)
        vnet_integration_enabled = optional(bool, null)
      }), null)
    })
    service_mesh_profile = optional(object({
      mode                             = optional(string, null) # "Istio" Requires Microsoft.ContainerService/AzureServiceMeshPreview Feature Registration
      internal_ingress_gateway_enabled = optional(bool, false)
      external_ingress_gateway_enabled = optional(bool, false)
    }), null)
    cluster_identity_system_managed = optional(bool, true)
  })
```

Default:

```json
{
  "managed_addons": {
    "image_cleaner": false,
    "keda": false,
    "oidc_issuer": false,
    "open_service_mesh": false
  },
  "security_options": {
    "enable_host_encryption": false,
    "enable_self_managed_keys": false
  },
  "storage_profile_configuration": {
    "blob_driver_enabled": true,
    "disk_driver_version": "v1"
  }
}
```

### <a name="input_container_registries"></a> [container\_registries](#input\_container\_registries)

Description: Map of container registries available to the module

Type: `map(any)`

Default: `{}`

### <a name="input_k8s_spot_pool_configurations"></a> [k8s\_spot\_pool\_configurations](#input\_k8s\_spot\_pool\_configurations)

Description: Map of spot worker pools to be created in the AKS cluster

Type:

```hcl
map(object({
    name               = string
    pool_sku           = string
    pool_min_size      = optional(number, 0)
    pool_max_size      = optional(number, 3)
    os_disk_size_gb    = number
    os_sku             = optional(string, null)
    os_type            = optional(string, null)
    max_pods_per_node  = number
    spot_max_price     = number
    node_subnet_cidr   = optional(list(string), null)
    node_subnet_key    = optional(string, null)
    pod_subnet_cidr    = optional(list(string), null)
    pod_subnet_key     = optional(string, null)
    k8s_labels         = optional(map(string), {})
    k8s_taints         = optional(list(string), [])
    availability_zones = list(string)
    naming_conventions_override = optional(object({
      prefixes      = optional(list(string), [])
      suffixes      = optional(list(string), [])
      random_length = optional(number, null)
      passthrough   = optional(bool, null)
    }), null)
    upgrade_settings = optional(object({
      max_surge = optional(string, null)
    }), null)
  }))
```

Default: `{}`

### <a name="input_k8s_system_pool_configuration"></a> [k8s\_system\_pool\_configuration](#input\_k8s\_system\_pool\_configuration)

Description: System pool configuration to be created in the AKS cluster

Type:

```hcl
object({
    pool_sku           = string
    pool_min_size      = optional(number, 1)
    pool_max_size      = optional(number, 3)
    os_disk_size_gb    = number
    os_sku             = optional(string, null)
    max_pods_per_node  = number
    node_subnet_cidr   = optional(list(string), null)
    node_subnet_key    = optional(string, null)
    pod_subnet_cidr    = optional(list(string), null)
    pod_subnet_key     = optional(string, null)
    k8s_labels         = optional(map(string), {})
    k8s_taints         = optional(list(string), [])
    availability_zones = list(string)
    upgrade_settings = optional(object({
      max_surge = optional(string, null)
    }), null)
  })
```

Default:

```json
{
  "availability_zones": [],
  "max_pods_per_node": 100,
  "node_subnet_cidr": [],
  "os_disk_size_gb": 45,
  "pool_max_size": 2,
  "pool_min_size": 1,
  "pool_sku": "Standard_D4as_v4"
}
```

### <a name="input_k8s_worker_pool_configurations"></a> [k8s\_worker\_pool\_configurations](#input\_k8s\_worker\_pool\_configurations)

Description: Map of worker pools to be created in the AKS cluster

Type:

```hcl
map(object({
    name               = string
    pool_sku           = string
    pool_min_size      = optional(number, 0)
    pool_max_size      = optional(number, 3)
    os_disk_size_gb    = number
    os_sku             = optional(string, null)
    os_type            = optional(string, null)
    workload_runtime   = optional(string, null)
    max_pods_per_node  = number
    node_subnet_cidr   = optional(list(string), null)
    node_subnet_key    = optional(string, null)
    pod_subnet_cidr    = optional(list(string), null)
    pod_subnet_key     = optional(string, null)
    k8s_labels         = optional(map(string), {})
    k8s_taints         = optional(list(string), [])
    availability_zones = list(string)
    naming_conventions_override = optional(object({
      prefixes      = optional(list(string), [])
      suffixes      = optional(list(string), [])
      random_length = optional(number, null)
      passthrough   = optional(bool, null)
    }), null)
    upgrade_settings = optional(object({
      max_surge = optional(string, null)
    }), null)
  }))
```

Default: `{}`

### <a name="input_naming_convention"></a> [naming\_convention](#input\_naming\_convention)

Description: Naming convention to be used (random, prefix, suffix, passthrough) for sub resources in the module

Type:

```hcl
object({
    cluster_name = optional(object({
      prefixes      = optional(list(string), null)
      suffixes      = optional(list(string), null)
      random_length = optional(number, null)
      passthrough   = optional(bool, null)
      use_slug      = optional(bool, null)
    }), null)
    default_node_pool = optional(object({
      prefixes      = optional(list(string), null)
      suffixes      = optional(list(string), null)
      random_length = optional(number, null)
      passthrough   = optional(bool, null)
      use_slug      = optional(bool, null)
    }), null)
    node_resource_group = optional(object({
      prefixes      = optional(list(string), null)
      suffixes      = optional(list(string), null)
      random_length = optional(number, null)
      passthrough   = optional(bool, null)
      use_slug      = optional(bool, null)
    }), null)
    node_pools = optional(object({
      prefixes      = optional(list(string), null)
      suffixes      = optional(list(string), null)
      random_length = optional(number, null)
      passthrough   = optional(bool, null)
      use_slug      = optional(bool, null)
    }), null)
    virtual_network = optional(object({
      prefixes      = optional(list(string), null)
      suffixes      = optional(list(string), null)
      random_length = optional(number, null)
      passthrough   = optional(bool, null)
      use_slug      = optional(bool, null)
    }), null)
  })
```

Default: `null`

### <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups)

Description: Map of resource groups available to the module

Type: `map(any)`

Default: `{}`

### <a name="input_user_defined_routes"></a> [user\_defined\_routes](#input\_user\_defined\_routes)

Description: Map of user defined routes available to the module

Type: `map(any)`

Default: `null`

### <a name="input_vnets"></a> [vnets](#input\_vnets)

Description: Map of virtual networks available to the module

Type: `map(any)`

Default: `null`

## Resources

The following resources are used by this module:

- [azurecaf_name.azurerm_application_gateway_aks_ingress](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_disk_encryption_set_aks_customer_managed_key](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_key_vault_aks_customer_managed_keys_encryption](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_kubernetes_cluster_k8s](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_kubernetes_cluster_node_pool_spot_pool](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_kubernetes_cluster_node_pool_worker_pool](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_network_security_group_aks_spot_pool_nodes](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_network_security_group_aks_system_pool_nodes](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_network_security_group_aks_worker_pool_nodes](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_network_security_group_app_gateway](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_network_security_group_ingress_ilb](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_public_ip_app_gateway](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_resource_group_cluster](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_resource_group_network](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_resource_group_security](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_subnet_aks_api_server](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_subnet_aks_spot_pool_nodes](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_subnet_aks_spot_pool_pods](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_subnet_aks_system_pool_nodes](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_subnet_aks_system_pool_pods](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_subnet_aks_worker_pool_nodes](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_subnet_aks_worker_pool_pods](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_subnet_app_gateway](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_subnet_ingress_ilb](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_user_assigned_identity_app_gateway_controller](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_user_assigned_identity_app_gateway_secrets](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_user_assigned_identity_cluster_control_plane](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.azurerm_virtual_network_aks_vnet](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.default_node_pool](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurecaf_name.default_node_pool_temporary_name_for_rotation](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) (resource)
- [azurerm_application_gateway.aks_ingress](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) (resource)
- [azurerm_disk_encryption_set.aks_customer_managed_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) (resource)
- [azurerm_key_vault.aks_customer_managed_keys_encryption](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) (resource)
- [azurerm_key_vault_access_policy.aks_customer_managed_keys_encryption](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) (resource)
- [azurerm_key_vault_access_policy.aks_customer_managed_keys_encryption_devops_agent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) (resource)
- [azurerm_key_vault_key.aks_customer_managed_keys_encryption](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) (resource)
- [azurerm_kubernetes_cluster.k8s](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) (resource)
- [azurerm_kubernetes_cluster_node_pool.spot_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) (resource)
- [azurerm_kubernetes_cluster_node_pool.worker_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) (resource)
- [azurerm_monitor_data_collection_rule.container_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule) (resource)
- [azurerm_monitor_data_collection_rule_association.container_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) (resource)
- [azurerm_network_security_group.aks_spot_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_network_security_group.aks_system_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_network_security_group.aks_worker_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_network_security_group.app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_network_security_group.ingress_ilb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_network_security_rule.aks_spot_pool_deny_ssh_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_network_security_rule.aks_system_pool_nodes_deny_ssh_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_network_security_rule.aks_worker_pool_deny_ssh_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_network_security_rule.app_gateway_allow_443_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_network_security_rule.app_gateway_allow_80_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_network_security_rule.app_gateway_allow_all_outbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_network_security_rule.app_gateway_allow_control_plane_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_network_security_rule.app_gateway_allow_health_probes_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_public_ip.app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) (resource)
- [azurerm_resource_group.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_resource_group.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_resource_group.security](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_role_assignment.aks_cluster_virtual_network_network_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.aks_kublet_node_rg_virtual_machine_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.aks_sp_container_registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.app_gateway_controller_app_gateway_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.app_gateway_controller_app_gateway_rg_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.app_gateway_controller_app_gateway_secrets_managed_identity_operator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.cluster_control_plane_private_zone_dns_zone_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.cluster_control_plane_vnet_dns_zone_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.oms_agent_monitoring_metrics_publisher](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_subnet.aks_api_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet.aks_spot_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet.aks_spot_pool_pods](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet.aks_system_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet.aks_system_pool_pods](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet.aks_worker_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet.aks_worker_pool_pods](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet.app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet.ingress_ilb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet_network_security_group_association.aks_spot_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) (resource)
- [azurerm_subnet_network_security_group_association.aks_worker_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) (resource)
- [azurerm_subnet_network_security_group_association.app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) (resource)
- [azurerm_subnet_network_security_group_association.ingress_ilb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) (resource)
- [azurerm_subnet_route_table_association.hub_egress_aks_spot_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) (resource)
- [azurerm_subnet_route_table_association.hub_egress_aks_system_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) (resource)
- [azurerm_subnet_route_table_association.hub_egress_aks_worker_pool_noes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) (resource)
- [azurerm_user_assigned_identity.app_gateway_controller](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)
- [azurerm_user_assigned_identity.app_gateway_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)
- [azurerm_user_assigned_identity.cluster_control_plane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)
- [azurerm_virtual_network.aks_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) (data source)

## Outputs

The following outputs are exported:

### <a name="output_app_gateway"></a> [app\_gateway](#output\_app\_gateway)

Description: application gateway object created by module

### <a name="output_app_gateway_user_managed_identity"></a> [app\_gateway\_user\_managed\_identity](#output\_app\_gateway\_user\_managed\_identity)

Description: user managed identity object of the App Gateway created by the module used for pulling secrets from Key Vault

### <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id)

Description: id of the AKS cluster

### <a name="output_cluster_managed_resource_group_name"></a> [cluster\_managed\_resource\_group\_name](#output\_cluster\_managed\_resource\_group\_name)

Description: name of the AKS cluster managed resource group

### <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name)

Description: name of the AKS cluster

### <a name="output_cluster_resource_group"></a> [cluster\_resource\_group](#output\_cluster\_resource\_group)

Description: cluster resource group object created by module

### <a name="output_kubelet_identity"></a> [kubelet\_identity](#output\_kubelet\_identity)

Description: kubelet identity object of the AKS cluster

### <a name="output_kubernetes_admin_config"></a> [kubernetes\_admin\_config](#output\_kubernetes\_admin\_config)

Description: kubernetes admin config object created by module

### <a name="output_kubernetes_config"></a> [kubernetes\_config](#output\_kubernetes\_config)

Description: kubernetes config object created by module

### <a name="output_network_resource_group"></a> [network\_resource\_group](#output\_network\_resource\_group)

Description: network resource group object created by module

### <a name="output_security_resource_group"></a> [security\_resource\_group](#output\_security\_resource\_group)

Description: security resource group object created by module

### <a name="output_virtual_network"></a> [virtual\_network](#output\_virtual\_network)

Description: virtual network object created by module


<!-- END_TF_DOCS -->
