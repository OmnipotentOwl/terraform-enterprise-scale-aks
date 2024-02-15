<!-- BEGIN_TF_DOCS -->


## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.3.0)

- <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) (>= 1.2.23)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.65.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.65.0)

## Modules

The following Modules are called:

### <a name="module_private_storage_class"></a> [private\_storage\_class](#module\_private\_storage\_class)

Source: ../azure-private-storage-class

Version:

## Required Inputs

The following input variables are required:

### <a name="input_aks_cluster"></a> [aks\_cluster](#input\_aks\_cluster)

Description: The AKS cluster object to use for Dapr.

Type:

```hcl
object({
    id                  = string
    name                = string
    resource_group_name = string
    location            = string
    node_resource_group = string
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_dapr_configuration_settings"></a> [dapr\_configuration\_settings](#input\_dapr\_configuration\_settings)

Description: The Dapr configuration settings to use for Dapr.

Type: `any`

Default: `{}`

### <a name="input_dapr_storage_class_name"></a> [dapr\_storage\_class\_name](#input\_dapr\_storage\_class\_name)

Description: The name of the storage class to use for Dapr.

Type: `string`

Default: `"azurefile-csi"`

### <a name="input_enable_private_storage"></a> [enable\_private\_storage](#input\_enable\_private\_storage)

Description: Enable private storage for Dapr.

Type: `bool`

Default: `false`

### <a name="input_enable_zonal_replication"></a> [enable\_zonal\_replication](#input\_enable\_zonal\_replication)

Description: Enable zonal replication for the storage account.

Type: `bool`

Default: `false`

### <a name="input_private_endpoint_subnet"></a> [private\_endpoint\_subnet](#input\_private\_endpoint\_subnet)

Description: The subnet to use for the private endpoint.

Type:

```hcl
object({
    id                  = string
    name                = string
    resource_group_name = string
  })
```

Default:

```json
{
  "id": null,
  "name": null,
  "resource_group_name": null
}
```

### <a name="input_service_mesh_enabled"></a> [service\_mesh\_enabled](#input\_service\_mesh\_enabled)

Description: Is service mesh enabled for Dapr.

Type: `bool`

Default: `false`

## Resources

The following resources are used by this module:

- [azurerm_kubernetes_cluster_extension.dapr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_extension) (resource)
- [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) (data source)

## Outputs

No outputs.


<!-- END_TF_DOCS -->
