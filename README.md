# terraform-azurerm-enterprise-scale-aks
Terraform Module for deploying an AKS cluster following Microsoft's Cloud Adoption Framework

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | >= 0.6.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.5.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | >= 1.2.23 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.65.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | 1.2.26 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.71.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.azurerm_application_gateway_aks_ingress](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_disk_encryption_set_aks_customer_managed_key](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_key_vault_aks_customer_managed_keys_encryption](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_kubernetes_cluster_k8s](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_kubernetes_cluster_node_pool_spot_pool](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_kubernetes_cluster_node_pool_worker_pool](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_network_security_group_aks_spot_pool_nodes](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_network_security_group_aks_system_pool_nodes](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_network_security_group_aks_worker_pool_nodes](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_network_security_group_app_gateway](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_network_security_group_ingress_ilb](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_public_ip_app_gateway](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_resource_group_cluster](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_resource_group_network](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_resource_group_security](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_subnet_aks_api_server](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_subnet_aks_spot_pool_nodes](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_subnet_aks_spot_pool_pods](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_subnet_aks_system_pool_nodes](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_subnet_aks_system_pool_pods](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_subnet_aks_worker_pool_nodes](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_subnet_aks_worker_pool_pods](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_subnet_app_gateway](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_subnet_ingress_ilb](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_user_assigned_identity_app_gateway_controller](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_user_assigned_identity_app_gateway_secrets](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_user_assigned_identity_cluster_control_plane](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_virtual_network_aks_vnet](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.default_node_pool](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.default_node_pool_temporary_name_for_rotation](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_application_gateway.aks_ingress](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_disk_encryption_set.aks_customer_managed_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) | resource |
| [azurerm_key_vault.aks_customer_managed_keys_encryption](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.aks_customer_managed_keys_encryption](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.aks_customer_managed_keys_encryption_devops_agent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_key.aks_customer_managed_keys_encryption](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_kubernetes_cluster.k8s](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.spot_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_kubernetes_cluster_node_pool.worker_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_network_security_group.aks_spot_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.aks_system_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.aks_worker_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.ingress_ilb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.aks_spot_pool_deny_ssh_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.aks_system_pool_nodes_deny_ssh_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.aks_worker_pool_deny_ssh_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.app_gateway_allow_443_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.app_gateway_allow_80_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.app_gateway_allow_all_outbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.app_gateway_allow_control_plane_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.app_gateway_allow_health_probes_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.security](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.aks_cluster_virtual_network_network_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_kublet_node_rg_virtual_machine_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_sp_container_registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.app_gateway_controller_app_gateway_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.app_gateway_controller_app_gateway_rg_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.app_gateway_controller_app_gateway_secrets_managed_identity_operator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.cluster_control_plane_private_zone_dns_zone_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.cluster_control_plane_vnet_dns_zone_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.oms_agent_monitoring_metrics_publisher](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_subnet.aks_api_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.aks_spot_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.aks_spot_pool_pods](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.aks_system_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.aks_system_pool_pods](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.aks_worker_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.aks_worker_pool_pods](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.ingress_ilb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.aks_spot_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.aks_worker_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.ingress_ilb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.hub_egress_aks_spot_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_subnet_route_table_association.hub_egress_aks_system_pool_nodes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_subnet_route_table_association.hub_egress_aks_worker_pool_noes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_user_assigned_identity.app_gateway_controller](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.app_gateway_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.cluster_control_plane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_network.aks_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_configuration"></a> [aks\_configuration](#input\_aks\_configuration) | AKS configuration options for cluster provisioning | <pre>object({<br>    sku_tier                  = optional(string, "Free")<br>    automatic_upgrade_channel = optional(string, "stable")<br>    node_os_upgrade_channel   = optional(string, null) # required subscription Feature Registration "Microsoft.ContainerService/NodeOsUpgradeChannelPreview" # "None" | "Unmanaged" | "SecurityPatch" | "NodeImage"<br>    private_cluster = optional(object({<br>      enabled              = optional(bool, false)<br>      private_dns_zone_id  = optional(string, null)<br>      private_dns_zone_key = optional(string, null)<br>      enable_public_fqdn   = optional(bool, false)<br>      private_endpoint_subnet = optional(object({<br>        id                  = string<br>        name                = string<br>        resource_group_name = string<br>      }), null)<br>    }), null)<br>    managed_addons = object({<br>      open_service_mesh       = optional(bool, false)<br>      oidc_issuer             = optional(bool, false)<br>      keda                    = optional(bool, false)<br>      image_cleaner           = optional(bool, false)<br>      vertical_pod_autoscaler = optional(bool, false)<br>    })<br>    container_registries = optional(map(object({<br>      key    = optional(string, null)<br>      lz_key = optional(string, null)<br>      id     = optional(string, null)<br>    })), {})<br>    oms_agent = optional(object({<br>      log_analytics_workspace_id      = optional(string, null)<br>      msi_auth_for_monitoring_enabled = optional(bool, false)<br>    }), null)<br>    microsoft_defender = optional(object({<br>      log_analytics_workspace_id = optional(string, null)<br>      log_analytics_key          = optional(string, null)<br>    }), null)<br>    storage_profile = optional(object({<br>      blob_driver_enabled         = optional(bool, true)<br>      file_driver_enabled         = optional(bool, true)<br>      disk_driver_enabled         = optional(bool, true)<br>      disk_driver_version         = optional(string, "v1")<br>      snapshot_controller_enabled = optional(bool, true)<br>      }), {<br>      blob_driver_enabled         = true<br>      file_driver_enabled         = true<br>      disk_driver_enabled         = true<br>      disk_driver_version         = "v1"<br>      snapshot_controller_enabled = true<br>    })<br>    security_options = object({<br>      enable_host_encryption   = bool<br>      enable_self_managed_keys = bool<br>      run_command_enabled      = optional(bool, null)<br>      api_server_access_profile = optional(object({<br>        authorized_ip_ranges     = optional(list(string), null)<br>        subnet_cidr              = optional(string, null)<br>        subnet_key               = optional(string, null)<br>        vnet_integration_enabled = optional(bool, null)<br>      }), null)<br>    })<br>    service_mesh_profile = optional(object({<br>      mode                             = optional(string, null) # "Istio" Requires Microsoft.ContainerService/AzureServiceMeshPreview Feature Registration<br>      internal_ingress_gateway_enabled = optional(bool, false)<br>      external_ingress_gateway_enabled = optional(bool, false)<br>    }), null)<br>    cluster_identity_system_managed = optional(bool, true)<br>  })</pre> | <pre>{<br>  "managed_addons": {<br>    "image_cleaner": false,<br>    "keda": false,<br>    "oidc_issuer": false,<br>    "open_service_mesh": false<br>  },<br>  "security_options": {<br>    "enable_host_encryption": false,<br>    "enable_self_managed_keys": false<br>  },<br>  "storage_profile_configuration": {<br>    "blob_driver_enabled": true,<br>    "disk_driver_version": "v1"<br>  }<br>}</pre> | no |
| <a name="input_container_registries"></a> [container\_registries](#input\_container\_registries) | Map of container registries available to the module | `map(any)` | `{}` | no |
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | (required) global settings for the workload | <pre>object({<br>    prefixes      = optional(list(string), null)<br>    suffixes      = optional(list(string), null)<br>    random_length = optional(number, null)<br>    passthrough   = optional(bool, null)<br>  })</pre> | n/a | yes |
| <a name="input_k8s_spot_pool_configurations"></a> [k8s\_spot\_pool\_configurations](#input\_k8s\_spot\_pool\_configurations) | Map of spot worker pools to be created in the AKS cluster | <pre>map(object({<br>    name               = string<br>    pool_sku           = string<br>    pool_min_size      = optional(number, 0)<br>    pool_max_size      = optional(number, 3)<br>    os_disk_size_gb    = number<br>    os_sku             = optional(string, null)<br>    os_type            = optional(string, null)<br>    max_pods_per_node  = number<br>    spot_max_price     = number<br>    node_subnet_cidr   = optional(list(string), null)<br>    node_subnet_key    = optional(string, null)<br>    pod_subnet_cidr    = optional(list(string), null)<br>    pod_subnet_key     = optional(string, null)<br>    k8s_labels         = optional(map(string), {})<br>    k8s_taints         = optional(list(string), [])<br>    availability_zones = list(string)<br>    naming_conventions_override = optional(object({<br>      prefixes      = optional(list(string), [])<br>      suffixes      = optional(list(string), [])<br>      random_length = optional(number, null)<br>      passthrough   = optional(bool, null)<br>    }), null)<br>    upgrade_settings = optional(object({<br>      max_surge = optional(string, null)<br>    }), null)<br>  }))</pre> | `{}` | no |
| <a name="input_k8s_system_pool_configuration"></a> [k8s\_system\_pool\_configuration](#input\_k8s\_system\_pool\_configuration) | System pool configuration to be created in the AKS cluster | <pre>object({<br>    pool_sku           = string<br>    pool_min_size      = optional(number, 0)<br>    pool_max_size      = optional(number, 3)<br>    os_disk_size_gb    = number<br>    os_sku             = optional(string, null)<br>    max_pods_per_node  = number<br>    node_subnet_cidr   = optional(list(string), null)<br>    node_subnet_key    = optional(string, null)<br>    pod_subnet_cidr    = optional(list(string), null)<br>    pod_subnet_key     = optional(string, null)<br>    k8s_labels         = optional(map(string), {})<br>    k8s_taints         = optional(list(string), [])<br>    availability_zones = list(string)<br>    upgrade_settings = optional(object({<br>      max_surge = optional(string, null)<br>    }), null)<br>  })</pre> | <pre>{<br>  "availability_zones": [],<br>  "max_pods_per_node": 100,<br>  "node_subnet_cidr": [],<br>  "os_disk_size_gb": 45,<br>  "pool_max_size": 2,<br>  "pool_min_size": 0,<br>  "pool_sku": "Standard_D4as_v4"<br>}</pre> | no |
| <a name="input_k8s_worker_pool_configurations"></a> [k8s\_worker\_pool\_configurations](#input\_k8s\_worker\_pool\_configurations) | Map of worker pools to be created in the AKS cluster | <pre>map(object({<br>    name               = string<br>    pool_sku           = string<br>    pool_min_size      = optional(number, 0)<br>    pool_max_size      = optional(number, 3)<br>    os_disk_size_gb    = number<br>    os_sku             = optional(string, null)<br>    os_type            = optional(string, null)<br>    workload_runtime   = optional(string, null)<br>    max_pods_per_node  = number<br>    node_subnet_cidr   = optional(list(string), null)<br>    node_subnet_key    = optional(string, null)<br>    pod_subnet_cidr    = optional(list(string), null)<br>    pod_subnet_key     = optional(string, null)<br>    k8s_labels         = optional(map(string), {})<br>    k8s_taints         = optional(list(string), [])<br>    availability_zones = list(string)<br>    naming_conventions_override = optional(object({<br>      prefixes      = optional(list(string), [])<br>      suffixes      = optional(list(string), [])<br>      random_length = optional(number, null)<br>      passthrough   = optional(bool, null)<br>    }), null)<br>    upgrade_settings = optional(object({<br>      max_surge = optional(string, null)<br>    }), null)<br>  }))</pre> | `{}` | no |
| <a name="input_naming_convention"></a> [naming\_convention](#input\_naming\_convention) | Naming convention to be used (random, prefix, suffix, passthrough) for sub resources in the module | <pre>object({<br>    cluster_name = optional(object({<br>      prefixes      = optional(list(string), null)<br>      suffixes      = optional(list(string), null)<br>      random_length = optional(number, null)<br>      passthrough   = optional(bool, null)<br>      use_slug      = optional(bool, null)<br>    }), null)<br>    default_node_pool = optional(object({<br>      prefixes      = optional(list(string), null)<br>      suffixes      = optional(list(string), null)<br>      random_length = optional(number, null)<br>      passthrough   = optional(bool, null)<br>      use_slug      = optional(bool, null)<br>    }), null)<br>    node_resource_group = optional(object({<br>      prefixes      = optional(list(string), null)<br>      suffixes      = optional(list(string), null)<br>      random_length = optional(number, null)<br>      passthrough   = optional(bool, null)<br>      use_slug      = optional(bool, null)<br>    }), null)<br>    node_pools = optional(object({<br>      prefixes      = optional(list(string), null)<br>      suffixes      = optional(list(string), null)<br>      random_length = optional(number, null)<br>      passthrough   = optional(bool, null)<br>      use_slug      = optional(bool, null)<br>    }), null)<br>    virtual_network = optional(object({<br>      prefixes      = optional(list(string), null)<br>      suffixes      = optional(list(string), null)<br>      random_length = optional(number, null)<br>      passthrough   = optional(bool, null)<br>      use_slug      = optional(bool, null)<br>    }), null)<br>  })</pre> | `null` | no |
| <a name="input_network_configuration"></a> [network\_configuration](#input\_network\_configuration) | (required) network configuration for the AKS cluster | <pre>object({<br>    vnet_key = optional(string, null)<br>    vnet_configuration = optional(object({<br>      vnet_address_space = list(string)<br>      dns_servers        = optional(list(string), null)<br>    }), null)<br>    ip_versions = optional(list(string), null) # ["IPv4", "IPv6"] requires subscription Feature Registration "Microsoft.ContainerService/AKS-EnableDualStack".<br>    ingress_configuration = object({<br>      app_gateway = optional(object({<br>        sku                  = string<br>        min_size             = optional(number, 0)<br>        max_size             = optional(number, 10)<br>        subnet_address_space = list(string)<br>        availability_zones   = list(string)<br>      }))<br>      internal_loadbalancer_enabled              = bool<br>      internal_loadbalancer_subnet_address_space = optional(list(string), null)<br>    })<br>    cluster_configuration = optional(object({<br>      network_plugin      = optional(string, "azure")<br>      network_policy      = optional(string, "azure")<br>      network_plugin_mode = optional(string, null) # required subscription Feature Registration "Microsoft.ContainerService/AzureOverlayPreview"<br>      pod_cidr            = optional(string, null) # when network_plugin is set to "azure" and network_plugin_mode is set to "Overlay" pod_cidr can be specified<br>      ebpf_data_plane     = optional(string, null) # when ebpf_data_plane is set to "cilium" network_plugin must be set to "azure"<br>      }), {<br>      network_plugin = "azure"<br>      network_policy = "azure"<br>    })<br>    egress_configuration = optional(object({<br>      egress_type = optional(string, "loadBalancer") # loadBalancer | userDefinedRouting | managedNATGateway | userAssignedNATGateway<br>      udr_key     = optional(string, null)<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_region_name"></a> [region\_name](#input\_region\_name) | (required) region name to provision resources into | `string` | n/a | yes |
| <a name="input_user_defined_routes"></a> [user\_defined\_routes](#input\_user\_defined\_routes) | Map of user defined routes available to the module | `map(any)` | `null` | no |
| <a name="input_vnets"></a> [vnets](#input\_vnets) | Map of virtual networks available to the module | `map(any)` | `null` | no |
| <a name="input_workload_name"></a> [workload\_name](#input\_workload\_name) | (required) workload name to seed into globaly unique names for resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_gateway"></a> [app\_gateway](#output\_app\_gateway) | application gateway object created by module |
| <a name="output_app_gateway_user_managed_identity"></a> [app\_gateway\_user\_managed\_identity](#output\_app\_gateway\_user\_managed\_identity) | user managed identity object of the App Gateway created by the module used for pulling secrets from Key Vault |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | id of the AKS cluster |
| <a name="output_cluster_managed_resource_group_name"></a> [cluster\_managed\_resource\_group\_name](#output\_cluster\_managed\_resource\_group\_name) | name of the AKS cluster managed resource group |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | name of the AKS cluster |
| <a name="output_cluster_resource_group"></a> [cluster\_resource\_group](#output\_cluster\_resource\_group) | cluster resource group object created by module |
| <a name="output_kubelet_identity"></a> [kubelet\_identity](#output\_kubelet\_identity) | kubelet identity object of the AKS cluster |
| <a name="output_kubernetes_admin_config"></a> [kubernetes\_admin\_config](#output\_kubernetes\_admin\_config) | kubernetes admin config object created by module |
| <a name="output_kubernetes_config"></a> [kubernetes\_config](#output\_kubernetes\_config) | kubernetes config object created by module |
| <a name="output_network_resource_group"></a> [network\_resource\_group](#output\_network\_resource\_group) | network resource group object created by module |
| <a name="output_security_resource_group"></a> [security\_resource\_group](#output\_security\_resource\_group) | security resource group object created by module |
| <a name="output_virtual_network"></a> [virtual\_network](#output\_virtual\_network) | virtual network object created by module |
<!-- END_TF_DOCS -->
