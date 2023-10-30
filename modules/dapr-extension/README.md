
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | >= 1.2.23 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.65.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.65.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private_storage_class"></a> [private\_storage\_class](#module\_private\_storage\_class) | ../azure-private-storage-class | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster_extension.dapr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_extension) | resource |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_cluster"></a> [aks\_cluster](#input\_aks\_cluster) | The AKS cluster object to use for Dapr. | <pre>object({<br>    id                  = string<br>    name                = string<br>    resource_group_name = string<br>    location            = string<br>    node_resource_group = string<br>  })</pre> | n/a | yes |
| <a name="input_dapr_configuration_settings"></a> [dapr\_configuration\_settings](#input\_dapr\_configuration\_settings) | The Dapr configuration settings to use for Dapr. | `any` | `{}` | no |
| <a name="input_dapr_storage_class_name"></a> [dapr\_storage\_class\_name](#input\_dapr\_storage\_class\_name) | The name of the storage class to use for Dapr. | `string` | `"azurefile-csi"` | no |
| <a name="input_enable_private_storage"></a> [enable\_private\_storage](#input\_enable\_private\_storage) | Enable private storage for Dapr. | `bool` | `false` | no |
| <a name="input_enable_zonal_replication"></a> [enable\_zonal\_replication](#input\_enable\_zonal\_replication) | Enable zonal replication for the storage account. | `bool` | `false` | no |
| <a name="input_private_endpoint_subnet"></a> [private\_endpoint\_subnet](#input\_private\_endpoint\_subnet) | The subnet to use for the private endpoint. | <pre>object({<br>    id                  = string<br>    name                = string<br>    resource_group_name = string<br>  })</pre> | <pre>{<br>  "id": null,<br>  "name": null,<br>  "resource_group_name": null<br>}</pre> | no |
| <a name="input_service_mesh_enabled"></a> [service\_mesh\_enabled](#input\_service\_mesh\_enabled) | Is service mesh enabled for Dapr. | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
