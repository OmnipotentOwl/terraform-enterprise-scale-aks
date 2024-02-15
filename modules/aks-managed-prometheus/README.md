<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.8 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.74.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.91.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_data_collection_endpoint.dce](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_endpoint) | resource |
| [azurerm_monitor_data_collection_rule.dcr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule) | resource |
| [azurerm_monitor_data_collection_rule_association.dcra](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_monitor_workspace_id"></a> [azure\_monitor\_workspace\_id](#input\_azure\_monitor\_workspace\_id) | The ID of the Azure Monitor Log Analytics workspace to send monitoring data to | `string` | n/a | yes |
| <a name="input_azure_montior_workspace_location"></a> [azure\_montior\_workspace\_location](#input\_azure\_montior\_workspace\_location) | The location of the Azure Monitor Log Analytics workspace to send monitoring data to | `string` | n/a | yes |
| <a name="input_clsuter_name"></a> [clsuter\_name](#input\_clsuter\_name) | The name of the Kubernetes cluster to enable monitoring for | `string` | n/a | yes |
| <a name="input_clsuter_resource_group_name"></a> [clsuter\_resource\_group\_name](#input\_clsuter\_resource\_group\_name) | The resource group name of the Kubernetes cluster to enable monitoring for | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | The ID of the Kubernetes cluster to enable monitoring for | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
