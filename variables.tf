variable "workload_name" {
  type        = string
  description = "(required) workload name to seed into globaly unique names for resources"
}
variable "region_name" {
  type        = string
  description = "(required) region name to provision resources into"
}
variable "global_settings" {
  type = object({
    prefixes      = optional(list(string), null)
    suffixes      = optional(list(string), null)
    random_length = optional(number, null)
    passthrough   = optional(bool, null)
  })
  description = "(required) global settings for the workload"
}
variable "network_configuration" {
  type = object({
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
  description = "(required) network configuration for the AKS cluster"
}
variable "aks_configuration" {
  type = object({
    sku_tier                  = optional(string, "Free")
    automatic_upgrade_channel = optional(string, "stable")
    node_os_upgrade_channel   = optional(string, null) # required subscription Feature Registration "Microsoft.ContainerService/NodeOsUpgradeChannelPreview" # "None" | "Unmanaged" | "SecurityPatch" | "NodeImage"
    private_cluster = optional(object({
      enabled              = optional(bool, false)
      private_dns_zone_id  = optional(string, null)
      private_dns_zone_key = optional(string, null)
      enable_public_fqdn   = optional(bool, false)
      private_endpoint_subnet = object({
        id                  = string
        name                = string
        resource_group_name = string
      })
      private_storage = object({
        enable_built_in_storage_class = bool
        enable_zonal_replication      = bool
        existing_storage_class_name   = string
      })
    }), null)
    managed_addons = object({
      open_service_mesh = optional(bool, false)
      oidc_issuer       = optional(bool, false)
      dapr = optional(object({
        enabled                  = optional(bool, false)
        additional_configuration = optional(map(string), {})
      }), null)
      keda                    = optional(bool, false)
      image_cleaner           = optional(bool, false)
      vertical_pod_autoscaler = optional(bool, false)
    })
    container_registry_keys = optional(set(string), [])
    oms_agent = optional(object({
      log_analytics_workspace_id      = optional(string, null)
      msi_auth_for_monitoring_enabled = optional(bool, false)
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
      enable_host_encryption   = bool
      enable_self_managed_keys = bool
      run_command_enabled      = optional(bool, null)
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
  default = {
    private_cluster = null
    managed_addons = {
      open_service_mesh = false
      keda              = false
      image_cleaner     = false
      oidc_issuer       = false
    }
    storage_profile_configuration = {
      blob_driver_enabled = true
      disk_driver_version = "v1"
    }
    security_options = {
      enable_host_encryption   = false
      enable_self_managed_keys = false
    }
  }
  description = "AKS configuration options for cluster provisioning"
}
variable "k8s_system_pool_configuration" {
  type = object({
    pool_sku           = string
    pool_min_size      = optional(number, 0)
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
  default = {
    max_pods_per_node  = 100
    os_disk_size_gb    = 45
    pool_max_size      = 2
    pool_min_size      = 0
    pool_sku           = "Standard_D4as_v4"
    node_subnet_cidr   = []
    availability_zones = []
  }
  description = "System pool configuration to be created in the AKS cluster"
}
variable "k8s_spot_pool_configurations" {
  type = map(object({
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
  default     = {}
  description = "Map of spot worker pools to be created in the AKS cluster"
}
variable "k8s_worker_pool_configurations" {
  type = map(object({
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
  default     = {}
  description = "Map of worker pools to be created in the AKS cluster"
}
variable "naming_convention" {
  description = "Naming convention to be used (random, prefix, suffix, passthrough) for sub resources in the module"
  type = object({
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
  default = null
}

variable "vnets" {
  description = "Map of virtual networks available to the module"
  type        = map(any)
  default     = null
}

variable "user_defined_routes" {
  description = "Map of user defined routes available to the module"
  type        = map(any)
  default     = null
}
variable "container_registries" {
  type = map(object({
    id                  = string
    name                = string
    resource_group_name = string
  }))
  description = "Map of container registries available to the module"
  default     = {}
}
