resource "random_pet" "cluster" {
  length = 2
}
module "cluster" {
  source = "../.." # This is the path to the module in your filesystem

  workload_name       = "pc-${random_pet.cluster.id}"
  region_name         = "eastus"
  environment         = "dev"
  organization_suffix = "git"

  container_registry = azurerm_container_registry.registry
  network_configuration = {
    egress_configuration = {
      egress_type  = "loadBalancer"
      udr_resource = null
    }
    existing_vnet         = null
    ingress_configuration = null
    vnet_configuration = {
      dns_servers        = []
      vnet_address_space = ["10.1.0.0/16"]
    }
  }

  aks_configuration = {
    private_cluster = null
    managed_addons = {
      dapr                   = true
      defender_workspace_id  = null
      oidc_issuer            = true
      oms_agent_workspace_id = null
      open_service_mesh      = true
    }
    security_options = {
      enable_host_encryption   = true
      enable_self_managed_keys = false
    }
    gitops_bootstrapping_github = null
  }

  aks_update_maintenance_configuration = {
    aks_uptime_sku            = "Free"
    automatic_channel_upgrade = "stable"
  }

  k8s_system_pool_configuration = {
    availability_zones = [1, 2, 3]
    max_pods_per_node  = 200
    os_disk_size_gb    = 100
    pool_max_size      = 3
    pool_min_size      = 1
    pool_sku           = "Standard_D4as_v4"
    subnet_cidr        = ["10.1.4.0/22"]
  }
  k8s_worker_pool_configurations = [
    {
      availability_zones = [1, 2, 3]
      max_pods_per_node  = 200
      os_disk_size_gb    = 100
      pool_max_size      = 3
      pool_min_size      = 1
      pool_sku           = "Standard_D4as_v4"
      subnet_cidr        = ["10.1.16.0/20"]
      k8s_labels         = {}
      k8s_taints         = []
    }
  ]
}