resource "azurerm_monitor_data_collection_rule" "container_insights" {
  count = var.aks_configuration.container_insights != null ? var.aks_configuration.container_insights.msi_auth_for_monitoring_enabled ? 1 : 0 : 0

  name                = trim(substr("MSCI-${azurerm_kubernetes_cluster.k8s.location}-${azurerm_kubernetes_cluster.k8s.name}", 0, 63), "-")
  resource_group_name = azurerm_kubernetes_cluster.k8s.resource_group_name
  location            = azurerm_kubernetes_cluster.k8s.location
  kind                = "Linux"
  description         = "DCR for Azure Monitor Container Insights"

  destinations {
    log_analytics {
      workspace_resource_id = var.aks_configuration.container_insights.log_analytics_workspace_id
      name                  = "ciworkspace"
    }
  }

  data_flow {
    streams      = var.aks_configuration.container_insights.streams
    destinations = ["ciworkspace"]
  }

  dynamic "data_flow" {
    for_each = var.aks_configuration.container_insights.enable_syslog ? [1] : []
    content {
      streams      = ["Microsoft-Syslog"]
      destinations = ["ciworkspace"]
    }
  }

  data_sources {
    dynamic "syslog" {
      for_each = var.aks_configuration.container_insights.enable_syslog ? [1] : []
      content {
        streams        = ["Microsoft-Syslog"]
        facility_names = var.aks_configuration.container_insights.syslog_facilities
        log_levels     = var.aks_configuration.container_insights.syslog_levels
        name           = "sysLogsDataSource"
      }
    }

    extension {
      streams        = var.aks_configuration.container_insights.streams
      extension_name = "ContainerInsights"
      extension_json = jsonencode({
        "dataCollectionSettings" : {
          "interval" : var.aks_configuration.container_insights.data_collection_interval,
          "namespaceFilteringMode" : var.aks_configuration.container_insights.namespace_filtering_mode_for_data_collection,
          "namespaces" : var.aks_configuration.container_insights.namespaces_for_data_collection
          "enableContainerLogV2" : true
        }
      })
      name = "ContainerInsightsExtension"
    }
  }
}

resource "azurerm_monitor_data_collection_rule_association" "container_insights" {
  count = var.aks_configuration.container_insights != null ? var.aks_configuration.container_insights.msi_auth_for_monitoring_enabled ? 1 : 0 : 0

  name                    = "ContainerInsightsExtension"
  target_resource_id      = azurerm_kubernetes_cluster.k8s.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.container_insights[0].id
  description             = "Association of data collection rule. Deleting this association will break the data collection for this AKS Cluster."
}

module "managed_prometheus" {
  source = "./modules/aks-managed-prometheus"
  count  = local.provision_managed_prometheus_integration ? 1 : 0

  cluster_id                       = azurerm_kubernetes_cluster.k8s.id
  cluster_name                     = azurerm_kubernetes_cluster.k8s.name
  cluster_resource_group_name      = azurerm_kubernetes_cluster.k8s.resource_group_name
  azure_monitor_workspace_id       = var.aks_configuration.managed_prometheus.azure_monitor_workspace_id
  azure_monitor_workspace_location = var.aks_configuration.managed_prometheus.azure_monitor_workspace_location
}
