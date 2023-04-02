# terraform-azurerm-enterprise-scale-aks
Terraform Module for deploying an AKS cluster following Microsoft's Cloud Adoption Framework

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | >=0.6 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.5 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | >= 1.2.23 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.36 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 4.5.2 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.10.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 1.3.0 |
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | 1.2.23 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.45.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_flux_gitops_github"></a> [flux\_gitops\_github](#module\_flux\_gitops\_github) | ./modules/flux2-github-bootstrap | n/a |
| <a name="module_private_storage_class"></a> [private\_storage\_class](#module\_private\_storage\_class) | ./modules/azure-private-storage-class | n/a |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.dapr_addon](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) | resource |
| [azurecaf_name.azurerm_application_gateway_aks_ingress](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_disk_encryption_set_aks_customer_managed_key](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_key_vault_aks_customer_managed_keys_encryption](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_kubernetes_cluster_k8s](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_network_security_group_aks_spot_pool](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_network_security_group_aks_system_pool](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_network_security_group_aks_worker_pool](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_network_security_group_app_gateway](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_network_security_group_ingress_ilb](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_public_ip_app_gateway](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_resource_group_cluster](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_resource_group_network](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_resource_group_security](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_subnet_aks_spot_pool](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_subnet_aks_system_pool](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_subnet_aks_worker_pool](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_subnet_app_gateway](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_subnet_ingress_ilb](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_user_assigned_identity_app_gateway_controller](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_user_assigned_identity_app_gateway_secrets](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_user_assigned_identity_cluster_control_plane](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.azurerm_virtual_network_aks_vnet](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_application_gateway.aks_ingress](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_disk_encryption_set.aks_customer_managed_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) | resource |
| [azurerm_key_vault.aks_customer_managed_keys_encryption](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.aks_customer_managed_keys_encryption](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.aks_customer_managed_keys_encryption_devops_agent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_key.aks_customer_managed_keys_encryption](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_kubernetes_cluster.k8s](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.spot_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_kubernetes_cluster_node_pool.worker_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_network_security_group.aks_spot_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.aks_system_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.aks_worker_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.ingress_ilb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.aks_spot_pool_deny_ssh_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.aks_system_pool_deny_ssh_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
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
| [azurerm_role_assignment.aks_kublet_node_rg_managed_identity_operator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_kublet_node_rg_virtual_machine_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_kublet_security_rg_managed_identity_operator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_sp_container_registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.app_gateway_controller_app_gateway_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.app_gateway_controller_app_gateway_rg_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.app_gateway_controller_app_gateway_secrets_managed_identity_operator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.cluster_control_plane_private_zone_dns_zone_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.cluster_control_plane_vnet_dns_zone_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.oms_agent_monitoring_metrics_publisher](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_subnet.aks_spot_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.aks_system_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.aks_worker_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.ingress_ilb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.aks_spot_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.aks_worker_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.ingress_ilb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.hub_egress_aks_spot_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_subnet_route_table_association.hub_egress_aks_system_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_subnet_route_table_association.hub_egress_aks_worker_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_user_assigned_identity.app_gateway_controller](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.app_gateway_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.cluster_control_plane](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_network.aks_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_configuration"></a> [aks\_configuration](#input\_aks\_configuration) | AKS configuration options for cluster provisioning | <pre>object({<br>    private_cluster = object({<br>      private_dns_zone_id = string<br>      enable_public_fqdn  = optional(bool, false)<br>      private_endpoint_subnet = object({<br>        id                  = string<br>        name                = string<br>        resource_group_name = string<br>      })<br>      private_storage = object({<br>        enable_built_in_storage_class = bool<br>        enable_zonal_replication      = bool<br>        existing_storage_class_name   = string<br>      })<br>    })<br>    managed_addons = object({<br>      open_service_mesh      = optional(bool, false)<br>      oidc_issuer            = optional(bool, false)<br>      dapr                   = optional(bool, false)<br>      keda                   = optional(bool, false)<br>      image_cleaner          = optional(bool, false)<br>      oms_agent_workspace_id = optional(string)<br>      defender_workspace_id  = optional(string)<br>    })<br>    storage_profile_configuration = object({<br>      blob_driver_enabled = optional(bool, true)<br>      disk_driver_version = optional(string, "v1")<br>    })<br>    security_options = object({<br>      enable_host_encryption   = bool<br>      enable_self_managed_keys = bool<br>    })<br>    gitops_bootstrapping_github = object({<br>      organization_name = string<br>      repository_name   = string<br>      branch_name       = string<br>    })<br>  })</pre> | <pre>{<br>  "gitops_bootstrapping_github": null,<br>  "managed_addons": {<br>    "dapr": false,<br>    "defender_workspace_id": null,<br>    "image_cleaner": false,<br>    "keda": false,<br>    "oidc_issuer": false,<br>    "oms_agent_workspace_id": null,<br>    "open_service_mesh": true<br>  },<br>  "private_cluster": null,<br>  "security_options": {<br>    "enable_host_encryption": false,<br>    "enable_self_managed_keys": false<br>  },<br>  "storage_profile_configuration": {<br>    "blob_driver_enabled": true,<br>    "disk_driver_version": "v1"<br>  }<br>}</pre> | no |
| <a name="input_aks_update_maintenance_configuration"></a> [aks\_update\_maintenance\_configuration](#input\_aks\_update\_maintenance\_configuration) | AKS update maintenance configuration | <pre>object({<br>    aks_uptime_sku            = optional(string, "Free")<br>    automatic_channel_upgrade = optional(string, "stable")<br>  })</pre> | <pre>{<br>  "aks_uptime_sku": "Free",<br>  "automatic_channel_upgrade": "stable"<br>}</pre> | no |
| <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry) | (optional) container registry object to pull images from using the AKS cluster identity | <pre>object({<br>    id                  = string<br>    name                = string<br>    resource_group_name = string<br>  })</pre> | n/a | yes |
| <a name="input_deployment_itteration"></a> [deployment\_itteration](#input\_deployment\_itteration) | (optional) deployment itteration count to allow for multiple deployments into the same environment | `number` | `1` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (required) environment name to seed into globaly unique names for resources | `string` | n/a | yes |
| <a name="input_k8s_spot_pool_configurations"></a> [k8s\_spot\_pool\_configurations](#input\_k8s\_spot\_pool\_configurations) | List of spot worker pools to be created in the AKS cluster | <pre>list(object({<br>    pool_sku           = string<br>    pool_min_size      = optional(number, 0)<br>    pool_max_size      = optional(number, 3)<br>    os_disk_size_gb    = number<br>    max_pods_per_node  = number<br>    spot_max_price     = number<br>    subnet_cidr        = list(string)<br>    k8s_labels         = optional(map(string), {})<br>    k8s_taints         = optional(list(string), [])<br>    availability_zones = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_k8s_system_pool_configuration"></a> [k8s\_system\_pool\_configuration](#input\_k8s\_system\_pool\_configuration) | System pool configuration to be created in the AKS cluster | <pre>object({<br>    pool_sku           = string<br>    pool_min_size      = optional(number, 0)<br>    pool_max_size      = optional(number, 3)<br>    os_disk_size_gb    = number<br>    max_pods_per_node  = number<br>    subnet_cidr        = list(string)<br>    availability_zones = list(string)<br>  })</pre> | <pre>{<br>  "availability_zones": [],<br>  "max_pods_per_node": 100,<br>  "os_disk_size_gb": 45,<br>  "pool_max_size": 2,<br>  "pool_min_size": 0,<br>  "pool_sku": "Standard_D4as_v4",<br>  "subnet_cidr": []<br>}</pre> | no |
| <a name="input_k8s_worker_pool_configurations"></a> [k8s\_worker\_pool\_configurations](#input\_k8s\_worker\_pool\_configurations) | List of worker pools to be created in the AKS cluster | <pre>list(object({<br>    pool_sku           = string<br>    pool_min_size      = optional(number, 0)<br>    pool_max_size      = optional(number, 3)<br>    os_disk_size_gb    = number<br>    max_pods_per_node  = number<br>    subnet_cidr        = list(string)<br>    k8s_labels         = optional(map(string), {})<br>    k8s_taints         = optional(list(string), [])<br>    availability_zones = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_network_configuration"></a> [network\_configuration](#input\_network\_configuration) | (required) network configuration for the AKS cluster | <pre>object({<br>    existing_vnet = object({<br>      id                  = string<br>      name                = string<br>      resource_group_name = string<br>      location            = string<br><br>    })<br>    vnet_configuration = object({<br>      vnet_address_space = list(string)<br>      dns_servers        = list(string)<br>    })<br>    ingress_configuration = object({<br>      app_gateway = object({<br>        sku                  = string<br>        min_size             = optional(number, 0)<br>        max_size             = optional(number, 10)<br>        subnet_address_space = list(string)<br>        availability_zones   = list(string)<br>      })<br><br>      internal_loadbalancer_enabled              = bool<br>      internal_loadbalancer_subnet_address_space = list(string)<br>    })<br>    egress_configuration = object({<br>      egress_type = string<br>      udr_resource = object({<br>        id   = string<br>        name = string<br>      })<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_organization_suffix"></a> [organization\_suffix](#input\_organization\_suffix) | (required) organizational suffix to seed into globaly unique names for resources | `string` | n/a | yes |
| <a name="input_region_name"></a> [region\_name](#input\_region\_name) | (required) region name to provision resources into | `string` | n/a | yes |
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
| <a name="output_network_resource_group"></a> [network\_resource\_group](#output\_network\_resource\_group) | network resource group object created by module |
| <a name="output_security_resource_group"></a> [security\_resource\_group](#output\_security\_resource\_group) | security resource group object created by module |
| <a name="output_virtual_network"></a> [virtual\_network](#output\_virtual\_network) | virtual network object created by module |
<!-- END_TF_DOCS -->
