resource "azurerm_monitor_data_collection_endpoint" "dce" {
  name                = trim(substr("MSProm-${var.azure_monitor_workspace_location}-${var.cluster_name}", 0, 44), "-")
  resource_group_name = var.cluster_resource_group_name
  location            = var.azure_monitor_workspace_location
  kind                = "Linux"
}
resource "azurerm_monitor_data_collection_rule" "dcr" {
  name                        = trim(substr("MSProm-${var.azure_monitor_workspace_location}-${var.cluster_name}", 0, 63), "-")
  resource_group_name         = var.cluster_resource_group_name
  location                    = var.azure_monitor_workspace_location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.dce.id
  kind                        = "Linux"

  destinations {
    monitor_account {
      monitor_account_id = var.azure_monitor_workspace_id
      name               = "MonitoringAccount1"
    }
  }

  data_flow {
    streams      = ["Microsoft-PrometheusMetrics"]
    destinations = ["MonitoringAccount1"]
  }

  data_sources {
    prometheus_forwarder {
      streams = ["Microsoft-PrometheusMetrics"]
      name    = "PrometheusDataSource"
    }
  }

  description = "DCR for Azure Monitor Metrics Profile (Managed Prometheus)"
  depends_on = [
    azurerm_monitor_data_collection_endpoint.dce
  ]
}

resource "azurerm_monitor_data_collection_rule_association" "dcra" {
  name                    = trim(substr("MSProm-${var.azure_monitor_workspace_location}-${var.cluster_name}", 0, 63), "-")
  target_resource_id      = var.cluster_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr.id
  description             = "Association of data collection rule. Deleting this association will break the data collection for this AKS Cluster."
  depends_on = [
    azurerm_monitor_data_collection_rule.dcr
  ]
}
