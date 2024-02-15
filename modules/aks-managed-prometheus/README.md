<!-- BEGIN_TF_DOCS -->


## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.3.8)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.65.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.65.0)

## Modules

No modules.

## Required Inputs

The following input variables are required:

### <a name="input_azure_monitor_workspace_id"></a> [azure\_monitor\_workspace\_id](#input\_azure\_monitor\_workspace\_id)

Description: The ID of the Azure Monitor Log Analytics workspace to send monitoring data to

Type: `string`

### <a name="input_azure_monitor_workspace_location"></a> [azure\_monitor\_workspace\_location](#input\_azure\_monitor\_workspace\_location)

Description: The location of the Azure Monitor Log Analytics workspace to send monitoring data to

Type: `string`

### <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id)

Description: The ID of the Kubernetes cluster to enable monitoring for

Type: `string`

### <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name)

Description: The name of the Kubernetes cluster to enable monitoring for

Type: `string`

### <a name="input_cluster_resource_group_name"></a> [cluster\_resource\_group\_name](#input\_cluster\_resource\_group\_name)

Description: The resource group name of the Kubernetes cluster to enable monitoring for

Type: `string`

## Optional Inputs

No optional inputs.

## Resources

The following resources are used by this module:

- [azurerm_monitor_alert_prometheus_rule_group.kubernetes_recording_rules_rule_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_alert_prometheus_rule_group) (resource)
- [azurerm_monitor_alert_prometheus_rule_group.node_and_kubernetes_recording_rules_rule_group_win](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_alert_prometheus_rule_group) (resource)
- [azurerm_monitor_alert_prometheus_rule_group.node_recording_rules_rule_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_alert_prometheus_rule_group) (resource)
- [azurerm_monitor_alert_prometheus_rule_group.node_recording_rules_rule_group_win](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_alert_prometheus_rule_group) (resource)
- [azurerm_monitor_data_collection_endpoint.dce](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_endpoint) (resource)
- [azurerm_monitor_data_collection_rule.dcr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule) (resource)
- [azurerm_monitor_data_collection_rule_association.dcra](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) (resource)

## Outputs

No outputs.


<!-- END_TF_DOCS -->
