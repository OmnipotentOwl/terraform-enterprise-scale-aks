resource "azurerm_storage_account" "standard_files" {
  name                     = "st${local.standard_files_storage_account_suffix}"
  resource_group_name      = var.storage_resource_group.name
  location                 = var.storage_resource_group.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = var.zonal_replication ? "ZRS" : "LRS"

  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false

  network_rules {
    default_action = "Deny"
    bypass         = ["Logging", "Metrics", "AzureServices"]
    ip_rules       = []
  }

  tags = {
    k8s-azure-created-by = var.cluster_name
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_endpoint" "standard_files" {
  for_each = toset(["file"])

  name                = "pe-${azurerm_storage_account.standard_files.name}-${each.key}"
  resource_group_name = var.private_endpoint_subnet.resource_group_name
  location            = azurerm_storage_account.standard_files.location
  subnet_id           = var.private_endpoint_subnet.id
  private_service_connection {
    name                           = "psc-${azurerm_storage_account.standard_files.name}-${each.key}"
    private_connection_resource_id = azurerm_storage_account.standard_files.id
    is_manual_connection           = false
    subresource_names              = [each.key]
  }
  lifecycle {
    ignore_changes = [
      private_dns_zone_group,
      tags
    ]
  }
}

resource "azurerm_storage_account" "premium_files" {
  name                     = "st${local.premium_files_storage_account_suffix}"
  resource_group_name      = var.storage_resource_group.name
  location                 = var.storage_resource_group.location
  account_kind             = "FileStorage"
  account_tier             = "Premium"
  account_replication_type = var.zonal_replication ? "ZRS" : "LRS"

  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false

  network_rules {
    default_action = "Deny"
    bypass         = ["Logging", "Metrics", "AzureServices"]
    ip_rules       = []
  }

  tags = {
    k8s-azure-created-by = var.cluster_name
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_endpoint" "premium_files" {
  for_each = toset(["file"])

  name                = "pe-${azurerm_storage_account.premium_files.name}-${each.key}"
  resource_group_name = var.private_endpoint_subnet.resource_group_name
  location            = azurerm_storage_account.premium_files.location
  subnet_id           = var.private_endpoint_subnet.id
  private_service_connection {
    name                           = "psc-${azurerm_storage_account.premium_files.name}-${each.key}"
    private_connection_resource_id = azurerm_storage_account.premium_files.id
    is_manual_connection           = false
    subresource_names              = [each.key]
  }
  lifecycle {
    ignore_changes = [
      private_dns_zone_group,
      tags
    ]
  }
}

resource "azurerm_storage_account" "premium_blobfuse" {
  name                     = "st${local.premium_blobfuse_storage_account_suffix}"
  resource_group_name      = var.storage_resource_group.name
  location                 = var.storage_resource_group.location
  account_kind             = "BlockBlobStorage"
  account_tier             = "Premium"
  account_replication_type = var.zonal_replication ? "ZRS" : "LRS"

  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false

  network_rules {
    default_action = "Deny"
    bypass         = ["Logging", "Metrics", "AzureServices"]
    ip_rules       = []
  }

  tags = {
    k8s-azure-created-by = var.cluster_name
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_endpoint" "premium_blobfuse" {
  for_each = toset(["blob"])

  name                = "pe-${azurerm_storage_account.premium_blobfuse.name}-${each.key}"
  resource_group_name = var.private_endpoint_subnet.resource_group_name
  location            = azurerm_storage_account.premium_blobfuse.location
  subnet_id           = var.private_endpoint_subnet.id
  private_service_connection {
    name                           = "psc-${azurerm_storage_account.premium_blobfuse.name}-${each.key}"
    private_connection_resource_id = azurerm_storage_account.premium_blobfuse.id
    is_manual_connection           = false
    subresource_names              = [each.key]
  }
  lifecycle {
    ignore_changes = [
      private_dns_zone_group,
      tags
    ]
  }
}

resource "azurerm_storage_account" "premium_nfs" {
  name                     = "st${local.premium_nfs_storage_account_suffix}"
  resource_group_name      = var.storage_resource_group.name
  location                 = var.storage_resource_group.location
  account_kind             = "BlockBlobStorage"
  account_tier             = "Premium"
  account_replication_type = var.zonal_replication ? "ZRS" : "LRS"

  enable_https_traffic_only       = false # NFS doesnt support encryption
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false
  nfsv3_enabled                   = true
  is_hns_enabled                  = true

  network_rules {
    default_action = "Deny"
    bypass         = ["Logging", "Metrics", "AzureServices"]
    ip_rules       = []
  }

  tags = {
    k8s-azure-created-by = var.cluster_name
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_endpoint" "premium_nfs" {
  for_each = toset(["blob"])

  name                = "pe-${azurerm_storage_account.premium_nfs.name}-${each.key}"
  resource_group_name = var.private_endpoint_subnet.resource_group_name
  location            = azurerm_storage_account.premium_nfs.location
  subnet_id           = var.private_endpoint_subnet.id
  private_service_connection {
    name                           = "psc-${azurerm_storage_account.premium_nfs.name}-${each.key}"
    private_connection_resource_id = azurerm_storage_account.premium_nfs.id
    is_manual_connection           = false
    subresource_names              = [each.key]
  }
  lifecycle {
    ignore_changes = [
      private_dns_zone_group,
      tags
    ]
  }
}
