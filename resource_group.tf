resource "azurecaf_name" "azurerm_resource_group_network" {
  count = local.existing_vnet_defined ? 0 : 1

  name          = local.workload_name_sanitized
  resource_type = "azurerm_resource_group"
  suffixes = [
    "network",
    local.environment_sanitized,
    local.region_name_sanitized,
    format("%03d", var.deployment_itteration)
  ]
}
resource "azurerm_resource_group" "network" {
  count = local.existing_vnet_defined ? 0 : 1

  name     = azurecaf_name.azurerm_resource_group_network[0].result
  location = local.region_name_sanitized

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
resource "azurecaf_name" "azurerm_resource_group_cluster" {
  name          = local.workload_name_sanitized
  resource_type = "azurerm_resource_group"
  suffixes = [
    "cluster",
    local.environment_sanitized,
    local.region_name_sanitized,
    format("%03d", var.deployment_itteration)
  ]
  clean_input = true
}
resource "azurerm_resource_group" "cluster" {
  name     = azurecaf_name.azurerm_resource_group_cluster.result
  location = local.region_name_sanitized

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
resource "azurecaf_name" "azurerm_resource_group_security" {
  name          = local.workload_name_sanitized
  resource_type = "azurerm_resource_group"
  suffixes = [
    "security",
    local.environment_sanitized,
    local.region_name_sanitized,
    format("%03d", var.deployment_itteration)
  ]
  clean_input = true
}
resource "azurerm_resource_group" "security" {
  name     = azurecaf_name.azurerm_resource_group_security.result
  location = local.region_name_sanitized

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
