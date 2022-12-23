resource "azurecaf_name" "azurerm_network_security_group_app_gateway" {
  count = local.app_gateway_enabled ? 1 : 0

  name          = azurerm_subnet.app_gateway[0].name
  resource_type = "azurerm_network_security_group"
  suffixes      = [local.region_name_sanitized]
  clean_input   = true
}
resource "azurerm_network_security_group" "app_gateway" {
  count = local.app_gateway_enabled ? 1 : 0

  name                = azurecaf_name.azurerm_network_security_group_app_gateway[0].result
  location            = local.region_name_sanitized
  resource_group_name = azurerm_subnet.app_gateway[0].resource_group_name
}
resource "azurerm_network_security_rule" "app_gateway_allow_80_inbound" {
  count = local.app_gateway_enabled ? 1 : 0

  name                        = "Allow80InBound"
  description                 = "Allow ALL web traffic into 80. (If you wanted to allow-list specific IPs, this is where you'd list them.)"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_network_security_group.app_gateway[0].resource_group_name
  network_security_group_name = azurerm_network_security_group.app_gateway[0].name
}
resource "azurerm_network_security_rule" "app_gateway_allow_443_inbound" {
  count = local.app_gateway_enabled ? 1 : 0

  name                        = "Allow443InBound"
  description                 = "Allow ALL web traffic into 443. (If you wanted to allow-list specific IPs, this is where you'd list them.)"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_network_security_group.app_gateway[0].resource_group_name
  network_security_group_name = azurerm_network_security_group.app_gateway[0].name
}
resource "azurerm_network_security_rule" "app_gateway_allow_control_plane_inbound" {
  count = local.app_gateway_enabled ? 1 : 0

  name                        = "AllowControlPlaneInBound"
  description                 = "Allow Azure Control Plane in. (https://docs.microsoft.com/azure/application-gateway/configuration-infrastructure#network-security-groups)"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "65200-65535"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.app_gateway[0].resource_group_name
  network_security_group_name = azurerm_network_security_group.app_gateway[0].name
}
resource "azurerm_network_security_rule" "app_gateway_allow_health_probes_inbound" {
  count = local.app_gateway_enabled ? 1 : 0

  name                        = "AllowHealthProbesInBound"
  description                 = "Allow Azure Health Probes in. (https://docs.microsoft.com/azure/application-gateway/configuration-infrastructure#network-security-groups)"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_network_security_group.app_gateway[0].resource_group_name
  network_security_group_name = azurerm_network_security_group.app_gateway[0].name
}
resource "azurerm_network_security_rule" "app_gateway_allow_all_outbound" {
  count = local.app_gateway_enabled ? 1 : 0

  name                        = "AllowAllOutBound"
  priority                    = 1000
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.app_gateway[0].resource_group_name
  network_security_group_name = azurerm_network_security_group.app_gateway[0].name
}
resource "azurerm_subnet_network_security_group_association" "app_gateway" {
  count = local.app_gateway_enabled ? 1 : 0

  subnet_id                 = azurerm_subnet.app_gateway[0].id
  network_security_group_id = azurerm_network_security_group.app_gateway[0].id
  depends_on = [
    azurerm_network_security_rule.app_gateway_allow_443_inbound,
    azurerm_network_security_rule.app_gateway_allow_control_plane_inbound,
    azurerm_network_security_rule.app_gateway_allow_health_probes_inbound
  ]
}
resource "azurecaf_name" "azurerm_network_security_group_ingress_ilb" {
  count = local.internal_loadbalancer_enabled ? 1 : 0

  name          = azurerm_subnet.ingress_ilb[0].name
  resource_type = "azurerm_network_security_group"
  suffixes = [
    local.region_name_sanitized
  ]
  clean_input = true
}
resource "azurerm_network_security_group" "ingress_ilb" {
  count = local.internal_loadbalancer_enabled ? 1 : 0

  name                = azurecaf_name.azurerm_network_security_group_ingress_ilb[0].result
  location            = local.region_name_sanitized
  resource_group_name = azurerm_subnet.ingress_ilb[0].resource_group_name
}
resource "azurerm_subnet_network_security_group_association" "ingress_ilb" {
  count = local.internal_loadbalancer_enabled ? 1 : 0

  subnet_id                 = azurerm_subnet.ingress_ilb[0].id
  network_security_group_id = azurerm_network_security_group.ingress_ilb[0].id
}
resource "azurecaf_name" "azurerm_network_security_group_aks_system_pool" {
  name          = azurerm_subnet.aks_system_pool.name
  resource_type = "azurerm_network_security_group"
  suffixes = [
    local.region_name_sanitized
  ]
  clean_input = true
}
resource "azurerm_network_security_group" "aks_system_pool" {
  name                = azurecaf_name.azurerm_network_security_group_aks_system_pool.result
  location            = local.region_name_sanitized
  resource_group_name = azurerm_subnet.aks_system_pool.resource_group_name
}
resource "azurerm_network_security_rule" "aks_system_pool_deny_ssh_inbound" {
  name                        = "DenySshInBound"
  description                 = "No SSH access allowed to nodes."
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.aks_system_pool.resource_group_name
  network_security_group_name = azurerm_network_security_group.aks_system_pool.name
}
resource "azurecaf_name" "azurerm_network_security_group_aks_spot_pool" {
  for_each = local.spot_pool_configurations

  name          = azurerm_subnet.aks_spot_pool[each.key].name
  resource_type = "azurerm_network_security_group"
  suffixes = [
    local.region_name_sanitized
  ]
  clean_input = true
}
resource "azurerm_network_security_group" "aks_spot_pool" {
  for_each = local.spot_pool_configurations

  name                = azurecaf_name.azurerm_network_security_group_aks_spot_pool[each.key].result
  location            = local.region_name_sanitized
  resource_group_name = azurerm_subnet.aks_spot_pool[each.key].resource_group_name
}
resource "azurerm_network_security_rule" "aks_spot_pool_deny_ssh_inbound" {
  for_each = local.spot_pool_configurations

  name                        = "DenySshInBound"
  description                 = "No SSH access allowed to nodes."
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.aks_spot_pool[each.key].resource_group_name
  network_security_group_name = azurerm_network_security_group.aks_spot_pool[each.key].name
}
resource "azurerm_subnet_network_security_group_association" "aks_spot_pool" {
  for_each = local.spot_pool_configurations

  subnet_id                 = azurerm_subnet.aks_spot_pool[each.key].id
  network_security_group_id = azurerm_network_security_group.aks_spot_pool[each.key].id
}
resource "azurecaf_name" "azurerm_network_security_group_aks_worker_pool" {
  for_each = local.worker_pool_configurations

  name          = azurerm_subnet.aks_worker_pool[each.key].name
  resource_type = "azurerm_network_security_group"
  suffixes = [
    local.region_name_sanitized
  ]
}
resource "azurerm_network_security_group" "aks_worker_pool" {
  for_each = local.worker_pool_configurations

  name                = azurecaf_name.azurerm_network_security_group_aks_worker_pool[each.key].result
  location            = local.region_name_sanitized
  resource_group_name = azurerm_subnet.aks_worker_pool[each.key].resource_group_name
}
resource "azurerm_network_security_rule" "aks_worker_pool_deny_ssh_inbound" {
  for_each = local.worker_pool_configurations

  name                        = "DenySshInBound"
  description                 = "No SSH access allowed to nodes."
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_network_security_group.aks_worker_pool[each.key].resource_group_name
  network_security_group_name = azurerm_network_security_group.aks_worker_pool[each.key].name
}
resource "azurerm_subnet_network_security_group_association" "aks_worker_pool" {
  for_each = local.worker_pool_configurations

  subnet_id                 = azurerm_subnet.aks_worker_pool[each.key].id
  network_security_group_id = azurerm_network_security_group.aks_worker_pool[each.key].id
}
