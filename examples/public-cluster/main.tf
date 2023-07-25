data "azurerm_client_config" "current" {}

resource "random_pet" "cluster" {
  length = 2
}
module "cluster" {
  source = "../.." # This is the path to the module in your filesystem

  workload_name = "pc-${random_pet.cluster.id}"
  region_name   = "eastus"
  global_settings = {
    suffixes = [
      "git",
      "dev"
    ],
    random_length = 4
  }
  network_configuration = {
    vnet_configuration = {
      dns_servers        = []
      vnet_address_space = ["10.1.0.0/16"]
    }
    egress_configuration = {
      egress_type = "loadBalancer"
    }
    ingress_configuration = null
    cluster_configuration = {
      network_plugin      = "azure"
      network_policy      = "azure"
      network_plugin_mode = "overlay"
    }
  }
  aks_configuration = {
    sku_tier                = "Free"
    node_os_upgrade_channel = "NodeImage"
    container_registry_keys = ["example"]
    managed_addons = {
      dapr = {
        enabled = true
      }
      keda        = true
      oidc_issuer = true
    }
    security_options = {
      enable_host_encryption   = true
      enable_self_managed_keys = false
    }
    service_mesh_profile = {
      mode                             = "Istio"
      external_ingress_gateway_enabled = true
    }
    gitops_bootstrapping_github = null
  }
  k8s_system_pool_configuration = {
    availability_zones = [1, 2, 3]
    max_pods_per_node  = 250
    os_disk_size_gb    = 100
    pool_max_size      = 3
    pool_min_size      = 1
    pool_sku           = "Standard_D4ads_v5"
    node_subnet_cidr   = ["10.1.4.0/24"]
  }
  k8s_worker_pool_configurations = {
    worker_pool_1 = {
      name               = "wp01"
      availability_zones = [1, 2, 3]
      max_pods_per_node  = 250
      os_disk_size_gb    = 100
      pool_max_size      = 3
      pool_min_size      = 1
      pool_sku           = "Standard_D4ads_v5"
      node_subnet_cidr   = ["10.1.5.0/24"]
      k8s_labels         = {}
      k8s_taints         = []
    }
  }

  container_registries = {
    example = azurerm_container_registry.registry
  }
}

resource "azurerm_role_assignment" "grant_example_admin_access_to_cluster" {
  scope                = module.cluster.cluster_id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azurerm_client_config.current.object_id
}
