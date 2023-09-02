module "private_storage_class" {
  count  = var.enable_private_storage ? 1 : 0
  source = "../azure-private-storage-class"

  cluster_name            = var.aks_cluster.name
  zonal_replication       = var.enable_zonal_replication
  private_endpoint_subnet = var.private_endpoint_subnet
  storage_resource_group = {
    id       = "${data.azurerm_subscription.current.id}/resourceGroups/${var.aks_cluster.node_resource_group}"
    name     = var.aks_cluster.node_resource_group
    location = var.aks_cluster.location
  }
}
