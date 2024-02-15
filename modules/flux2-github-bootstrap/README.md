<!-- BEGIN_TF_DOCS -->


## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 0.13.0)

- <a name="requirement_flux"></a> [flux](#requirement\_flux) (>= 1.0.1)

- <a name="requirement_github"></a> [github](#requirement\_github) (>= 4.5.2)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.1)

- <a name="requirement_tls"></a> [tls](#requirement\_tls) (>= 3.1.0)

## Providers

The following providers are used by this module:

- <a name="provider_flux"></a> [flux](#provider\_flux) (>= 1.0.1)

- <a name="provider_github"></a> [github](#provider\_github) (>= 4.5.2)

- <a name="provider_random"></a> [random](#provider\_random) (>= 3.5.1)

- <a name="provider_tls"></a> [tls](#provider\_tls) (>= 3.1.0)

## Modules

No modules.

## Required Inputs

The following input variables are required:

### <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name)

Description: name of the cluster to bootstrap in cloud provider

Type: `string`

### <a name="input_flux_configuration"></a> [flux\_configuration](#input\_flux\_configuration)

Description: configuration for flux2

Type:

```hcl
object({
    version                 = optional(string, null)
    registry                = optional(string, null)
    additional_tolerations  = optional(list(string), [])
    kustomization_overrides = optional(string, null)
  })
```

### <a name="input_kubernetes_configuration"></a> [kubernetes\_configuration](#input\_kubernetes\_configuration)

Description: configuration for kubernetes cluster

Type:

```hcl
object({
    host                   = string
    client_certificate     = optional(string, null)
    client_key             = optional(string, null)
    cluster_ca_certificate = optional(string, null)
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_github_configuration"></a> [github\_configuration](#input\_github\_configuration)

Description: configuration for github connection

Type:

```hcl
object({
    organization_name = string
    repository_name   = string
    branch_name       = optional(string, "main")
  })
```

Default: `null`

## Resources

The following resources are used by this module:

- [flux_bootstrap_git.this](https://registry.terraform.io/providers/fluxcd/flux/latest/docs/resources/bootstrap_git) (resource)
- [github_repository_deploy_key.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_deploy_key) (resource)
- [random_id.k8s_tracker](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)
- [tls_private_key.flux](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) (resource)
- [github_repository.main](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository) (data source)

## Outputs

No outputs.


<!-- END_TF_DOCS -->
