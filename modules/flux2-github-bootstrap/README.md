

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | >= 1.0.1 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 4.5.2 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_flux"></a> [flux](#provider\_flux) | 1.0.1 |
| <a name="provider_github"></a> [github](#provider\_github) | 5.32.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [flux_bootstrap_git.this](https://registry.terraform.io/providers/fluxcd/flux/latest/docs/resources/bootstrap_git) | resource |
| [github_repository_deploy_key.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_deploy_key) | resource |
| [tls_private_key.flux](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [github_repository.main](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | name of the cluster to bootstrap in cloud provider | `string` | n/a | yes |
| <a name="input_flux_configuration"></a> [flux\_configuration](#input\_flux\_configuration) | configuration for flux2 | <pre>object({<br>    version                 = optional(string, null)<br>    registry                = optional(string, null)<br>    additional_tolerations  = optional(list(string), [])<br>    kustomization_overrides = optional(string, null)<br>  })</pre> | n/a | yes |
| <a name="input_github_configuration"></a> [github\_configuration](#input\_github\_configuration) | configuration for github connection | <pre>object({<br>    organization_name = string<br>    repository_name   = string<br>    branch_name       = string<br>  })</pre> | `null` | no |
| <a name="input_kubernetes_configuration"></a> [kubernetes\_configuration](#input\_kubernetes\_configuration) | configuration for kubernetes cluster | <pre>object({<br>    host                   = string<br>    client_certificate     = optional(string, null)<br>    client_key             = optional(string, null)<br>    cluster_ca_certificate = optional(string, null)<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
