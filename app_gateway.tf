resource "azurerm_application_gateway" "aks_ingress" {
  count = local.app_gateway_enabled ? 1 : 0

  name                = local.app_gateway_name
  resource_group_name = local.existing_vnet_defined ? var.network_configuration.existing_vnet.resource_group_name : azurerm_virtual_network.aks_vnet[0].resource_group_name
  location            = local.existing_vnet_defined ? var.network_configuration.existing_vnet.location : azurerm_virtual_network.aks_vnet[0].location
  zones               = var.network_configuration.ingress_configuration.app_gateway.availability_zones
  enable_http2        = true

  sku {
    name = coalesce(var.network_configuration.ingress_configuration.app_gateway.sku, "WAF_v2")
    tier = coalesce(var.network_configuration.ingress_configuration.app_gateway.sku, "WAF_v2")
  }
  autoscale_configuration {
    min_capacity = var.network_configuration.ingress_configuration.app_gateway.min_size
    max_capacity = var.network_configuration.ingress_configuration.app_gateway.max_size
  }

  gateway_ip_configuration {
    name      = "private"
    subnet_id = azurerm_subnet.app_gateway[0].id
  }

  frontend_port {
    name = "http-80-feport"
    port = 80
  }
  frontend_port {
    name = "https-443-feport"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "public-feip"
    public_ip_address_id = azurerm_public_ip.app_gateway[0].id
  }

  frontend_ip_configuration {
    name                          = "private-feip"
    subnet_id                     = azurerm_subnet.app_gateway[0].id
    private_ip_address            = local.app_gateway_enabled ? cidrhost(var.network_configuration.ingress_configuration.app_gateway.subnet_address_space[0], 4) : null
    private_ip_address_allocation = "Static"
  }

  backend_address_pool {
    name = "${local.existing_vnet_defined ? var.network_configuration.existing_vnet.name : azurerm_virtual_network.aks_vnet[0].name}-beap"
  }

  backend_http_settings {
    name                  = "${local.existing_vnet_defined ? var.network_configuration.existing_vnet.name : azurerm_virtual_network.aks_vnet[0].name}-be-htst"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }
  http_listener {
    name                           = "${local.existing_vnet_defined ? var.network_configuration.existing_vnet.name : azurerm_virtual_network.aks_vnet[0].name}-httplstn"
    frontend_ip_configuration_name = "private-feip"
    frontend_port_name             = "http-80-feport"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${local.existing_vnet_defined ? var.network_configuration.existing_vnet.name : azurerm_virtual_network.aks_vnet[0].name}-rqrt"
    rule_type                  = "Basic"
    http_listener_name         = "${local.existing_vnet_defined ? var.network_configuration.existing_vnet.name : azurerm_virtual_network.aks_vnet[0].name}-httplstn"
    backend_address_pool_name  = "${local.existing_vnet_defined ? var.network_configuration.existing_vnet.name : azurerm_virtual_network.aks_vnet[0].name}-beap"
    backend_http_settings_name = "${local.existing_vnet_defined ? var.network_configuration.existing_vnet.name : azurerm_virtual_network.aks_vnet[0].name}-be-htst"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.app_gateway_secrets[0].id
    ]
  }

  lifecycle {
    ignore_changes = all
  }
  depends_on = [
    azurerm_subnet_network_security_group_association.app_gateway
  ]
}

resource "azurerm_public_ip" "app_gateway" {
  count = local.app_gateway_enabled ? 1 : 0

  name                = local.app_gateway_public_ip_name
  resource_group_name = local.existing_vnet_defined ? var.network_configuration.existing_vnet.resource_group_name : azurerm_virtual_network.aks_vnet[0].resource_group_name
  location            = local.existing_vnet_defined ? var.network_configuration.existing_vnet.location : azurerm_virtual_network.aks_vnet[0].location
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = local.app_gateway_public_ip_name
  zones               = var.network_configuration.ingress_configuration.app_gateway.availability_zones

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
