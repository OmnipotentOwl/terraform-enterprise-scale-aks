

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.24.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.71.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_private_endpoint.premium_blobfuse](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.premium_files](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.premium_nfs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.standard_files](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_storage_account.premium_blobfuse](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account.premium_files](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account.premium_nfs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account.standard_files](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [kubernetes_storage_class_v1.premium_blobfuse](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class_v1) | resource |
| [kubernetes_storage_class_v1.premium_files](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class_v1) | resource |
| [kubernetes_storage_class_v1.premium_nfs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class_v1) | resource |
| [kubernetes_storage_class_v1.standard_files](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class_v1) | resource |
| [random_string.storage_account_name_seed](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the cluster | `string` | n/a | yes |
| <a name="input_private_endpoint_subnet"></a> [private\_endpoint\_subnet](#input\_private\_endpoint\_subnet) | (required) The subnet to create the private endpoint in | <pre>object({<br>    id                  = string<br>    name                = string<br>    resource_group_name = string<br>  })</pre> | n/a | yes |
| <a name="input_storage_resource_group"></a> [storage\_resource\_group](#input\_storage\_resource\_group) | (required) The resource group to create the storage accounts in | <pre>object({<br>    id       = string<br>    name     = string<br>    location = string<br>  })</pre> | n/a | yes |
| <a name="input_zonal_replication"></a> [zonal\_replication](#input\_zonal\_replication) | Enable zonal replication for the storage account | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_premium_blobfuse_storage_account"></a> [premium\_blobfuse\_storage\_account](#output\_premium\_blobfuse\_storage\_account) | premium azure blob private storage account |
| <a name="output_premium_blobfuse_storage_class_name"></a> [premium\_blobfuse\_storage\_class\_name](#output\_premium\_blobfuse\_storage\_class\_name) | premium azure blob private storage class name |
| <a name="output_premium_files_storage_account"></a> [premium\_files\_storage\_account](#output\_premium\_files\_storage\_account) | premium azure files private storage account |
| <a name="output_premium_files_storage_class_name"></a> [premium\_files\_storage\_class\_name](#output\_premium\_files\_storage\_class\_name) | premium azure files private storage class name |
| <a name="output_premium_nfs_storage_account"></a> [premium\_nfs\_storage\_account](#output\_premium\_nfs\_storage\_account) | premium azure nfs private storage account |
| <a name="output_premium_nfs_storage_class_name"></a> [premium\_nfs\_storage\_class\_name](#output\_premium\_nfs\_storage\_class\_name) | premium azure nfs private storage class name |
| <a name="output_standard_files_storage_account"></a> [standard\_files\_storage\_account](#output\_standard\_files\_storage\_account) | standard azure files private storage account |
| <a name="output_standard_files_storage_class_name"></a> [standard\_files\_storage\_class\_name](#output\_standard\_files\_storage\_class\_name) | standard azure files private storage class name |
<!-- END_TF_DOCS -->
