resource "azurerm_resource_group" "network" {
  count = local.existing_vnet_defined ? 0 : 1

  name     = "rg-${local.workload_name_sanitized}-network-${local.environment_sanitized}-${local.region_name_sanitized}"
  location = local.region_name_sanitized

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_resource_group" "cluster" {
  name     = "rg-${local.workload_name_sanitized}-cluster-${local.environment_sanitized}-${local.region_name_sanitized}"
  location = local.region_name_sanitized

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_resource_group" "security" {
  name     = "rg-${local.workload_name_sanitized}-security-${local.environment_sanitized}-${local.region_name_sanitized}"
  location = local.region_name_sanitized

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}