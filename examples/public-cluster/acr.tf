resource "random_string" "acr" {
  special = false
  length  = 8
}

resource "azurerm_container_registry" "registry" {
  name                = "cr${random_string.acr.result}"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.sample.name

  sku = "Basic"
}
