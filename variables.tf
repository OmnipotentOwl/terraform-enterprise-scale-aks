variable "workload_name" {
  type        = string
  description = "(required) workload name to seed into globaly unique names for resources"
}
variable "region_name" {
  type        = string
  description = "(required) region name to provision resources into"
}
variable "environment" {
  type        = string
  description = "(required) environment name to seed into globaly unique names for resources"
}
variable "organization_suffix" {
  type        = string
  description = "(required) organizational suffix to seed into globaly unique names for resources"
}
variable "container_registry" {
  type = object({
    id                  = string
    name                = string
    resource_group_name = string
  })
  description = "(required) container registry object to pull images from"
}
variable "network_configuration" {
  type = object({
    existing_vnet = object({
      id                  = string
      name                = string
      resource_group_name = string
      location            = string

    })
    vnet_configuration = object({
      vnet_address_space = list(string)
      dns_servers        = list(string)
    })
    ingress_configuration = object({
      app_gateway = object({
        sku                  = string
        min_size             = optional(number, 0)
        max_size             = optional(number, 10)
        subnet_address_space = list(string)
        availability_zones   = list(string)
      })

      internal_loadbalancer_enabled              = bool
      internal_loadbalancer_subnet_address_space = list(string)
    })
    egress_configuration = object({
      egress_type = string
      udr_resource = object({
        id   = string
        name = string
      })
    })
  })
  description = "(required) network configuration for the AKS cluster"
}
variable "aks_configuration" {
  type = object({
    private_cluster = object({
      private_dns_zone_id = string
      enable_public_fqdn  = optional(bool, false)
    })
    managed_addons = object({
      open_service_mesh      = optional(bool, false)
      oidc_issuer            = optional(bool, false)
      dapr                   = optional(bool, false)
      oms_agent_workspace_id = optional(string)
      defender_workspace_id  = optional(string)
    })
    security_options = object({
      enable_host_encryption   = bool
      enable_self_managed_keys = bool
    })
    gitops_bootstrapping_github = object({
      organization_name = string
      repository_name   = string
      branch_name       = string
    })
  })
  default = {
    private_cluster = null
    managed_addons = {
      open_service_mesh      = true
      dapr                   = false
      oidc_issuer            = false
      oms_agent_workspace_id = null
      defender_workspace_id  = null
    }
    security_options = {
      enable_host_encryption   = false
      enable_self_managed_keys = false
    }
    gitops_bootstrapping_github = null
  }
  description = "AKS configuration options for cluster provisioning"
}
variable "aks_update_maintenance_configuration" {
  type = object({
    aks_uptime_sku            = optional(string, "Free")
    automatic_channel_upgrade = optional(string, "stable")
  })
  default = {
    aks_uptime_sku            = "Free"
    automatic_channel_upgrade = "stable"
  }
  description = "AKS update maintenance configuration"
}
variable "k8s_system_pool_configuration" {
  type = object({
    pool_sku           = string
    pool_min_size      = optional(number, 0)
    pool_max_size      = optional(number, 3)
    os_disk_size_gb    = number
    max_pods_per_node  = number
    subnet_cidr        = list(string)
    availability_zones = list(string)
  })
  default = {
    max_pods_per_node  = 100
    os_disk_size_gb    = 45
    pool_max_size      = 2
    pool_min_size      = 0
    pool_sku           = "Standard_D4as_v4"
    subnet_cidr        = []
    availability_zones = []
  }
  description = "System pool configuration to be created in the AKS cluster"
}
variable "k8s_spot_pool_configurations" {
  type = list(object({
    pool_sku           = string
    pool_min_size      = optional(number, 0)
    pool_max_size      = optional(number, 3)
    os_disk_size_gb    = number
    max_pods_per_node  = number
    spot_max_price     = number
    subnet_cidr        = list(string)
    k8s_labels         = map(string)
    k8s_taints         = list(string)
    availability_zones = list(string)
  }))
  default     = []
  description = "List of spot worker pools to be created in the AKS cluster"
}
variable "k8s_worker_pool_configurations" {
  type = list(object({
    pool_sku           = string
    pool_min_size      = optional(number, 0)
    pool_max_size      = optional(number, 3)
    os_disk_size_gb    = number
    max_pods_per_node  = number
    subnet_cidr        = list(string)
    k8s_labels         = map(string)
    k8s_taints         = list(string)
    availability_zones = list(string)
  }))
  default     = []
  description = "List of worker pools to be created in the AKS cluster"
}
