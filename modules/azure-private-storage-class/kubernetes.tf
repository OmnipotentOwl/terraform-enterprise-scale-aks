resource "kubernetes_storage_class_v1" "standard_files" {
  metadata {
    name = "private-azurefile-csi"
  }
  storage_provisioner    = "file.csi.azure.com"
  allow_volume_expansion = true
  parameters = {
    skuName        = "Standard_${var.zonal_replication ? "ZRS" : "LRS"}"
    resourceGroup  = azurerm_storage_account.standard_files.resource_group_name
    storageAccount = azurerm_storage_account.standard_files.name
    server         = "${azurerm_storage_account.standard_files.name}.privatelink.file.core.windows.net"
  }
  reclaim_policy      = "Delete"
  volume_binding_mode = "Immediate"
  # https://linux.die.net/man/8/mount.cifs
  # reduce probability of reconnect race
  # reduce latency for metadata-heavy workload
  mount_options = ["dir_mode=0777", "file_mode=0777", "uid=1000", "gid=1000", "mfsymlinks", "cache=strict", "nosharesock", "actimeo=30"]
}

resource "kubernetes_storage_class_v1" "premium_files" {
  metadata {
    name = "private-azurefile-csi-premium"
  }
  storage_provisioner    = "file.csi.azure.com"
  allow_volume_expansion = true
  parameters = {
    skuName        = "Premium_${var.zonal_replication ? "ZRS" : "LRS"}"
    resourceGroup  = azurerm_storage_account.premium_files.resource_group_name
    storageAccount = azurerm_storage_account.premium_files.name
    server         = "${azurerm_storage_account.premium_files.name}.privatelink.file.core.windows.net"
  }
  reclaim_policy      = "Delete"
  volume_binding_mode = "Immediate"
  # https://linux.die.net/man/8/mount.cifs
  # reduce probability of reconnect race
  # reduce latency for metadata-heavy workload
  mount_options = ["dir_mode=0777", "file_mode=0777", "uid=1000", "gid=1000", "mfsymlinks", "cache=strict", "nosharesock", "actimeo=30"]
}

resource "kubernetes_storage_class_v1" "premium_blobfuse" {
  metadata {
    name = "private-azureblob-fuse-premium"
  }
  storage_provisioner    = "blob.csi.azure.com"
  allow_volume_expansion = true
  parameters = {
    skuName        = "Premium_${var.zonal_replication ? "ZRS" : "LRS"}"
    resourceGroup  = azurerm_storage_account.premium_blobfuse.resource_group_name
    storageAccount = azurerm_storage_account.premium_blobfuse.name
    server         = "${azurerm_storage_account.premium_blobfuse.name}.privatelink.blob.core.windows.net"
    protocol       = "fuse"
  }
  reclaim_policy      = "Delete"
  volume_binding_mode = "Immediate"
  mount_options = [
    "-o allow_other",
    "--file-cache-timeout-in-seconds=120",
    "--use-attr-cache=true",
    "--cancel-list-on-mount-seconds=10", # prevent billing charges on mounting
    "-o attr_timeout=120",
    "-o entry_timeout=120",
    "-o negative_timeout=120",
    "--log-level=LOG_WARNING", # LOG_WARNING, LOG_INFO, LOG_DEBUG
    "--cache-size-mb=1000",    # Default will be 80% of available memory, eviction will happen beyond that.
  ]
}

resource "kubernetes_storage_class_v1" "premium_nfs" {
  metadata {
    name = "private-azureblob-nfs-premium"
  }
  storage_provisioner    = "blob.csi.azure.com"
  allow_volume_expansion = true
  parameters = {
    resourceGroup  = azurerm_storage_account.premium_nfs.resource_group_name
    storageAccount = azurerm_storage_account.premium_nfs.name
    server         = "${azurerm_storage_account.premium_nfs.name}.privatelink.blob.core.windows.net"
    protocol       = "nfs"
  }
  reclaim_policy      = "Delete"
  volume_binding_mode = "Immediate"
}
