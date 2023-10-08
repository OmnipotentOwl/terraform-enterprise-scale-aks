resource "azurecaf_name" "azurerm_resource_group_network" {
  count = local.existing_vnet_defined ? 0 : 1

  name          = "network"
  resource_type = "azurerm_resource_group"
  prefixes      = var.global_settings.prefixes
  suffixes      = var.global_settings.suffixes
  random_length = var.global_settings.random_length
  passthrough   = var.global_settings.passthrough
  clean_input   = true
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
  name          = "cluster"
  resource_type = "azurerm_resource_group"
  prefixes      = var.global_settings.prefixes
  suffixes      = var.global_settings.suffixes
  random_length = var.global_settings.random_length
  passthrough   = var.global_settings.passthrough
  clean_input   = true
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
  count         = var.aks_configuration.security_options.security_resource_group_key != null ? 0 : 1
  name          = "security"
  resource_type = "azurerm_resource_group"
  prefixes      = var.global_settings.prefixes
  suffixes      = var.global_settings.suffixes
  random_length = var.global_settings.random_length
  passthrough   = var.global_settings.passthrough
  clean_input   = true
}
resource "azurerm_resource_group" "security" {
  count    = var.aks_configuration.security_options.security_resource_group_key != null ? 0 : 1
  name     = azurecaf_name.azurerm_resource_group_security[0].result
  location = local.region_name_sanitized

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
