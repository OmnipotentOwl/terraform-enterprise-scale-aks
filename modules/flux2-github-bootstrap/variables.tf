variable "cluster_name" {
  type        = string
  description = "name of the cluster to bootstrap in cloud provider"
}
variable "kubernetes_configuration" {
  type = object({
    host                   = string
    client_certificate     = optional(string, null)
    client_key             = optional(string, null)
    cluster_ca_certificate = optional(string, null)
  })
  description = "configuration for kubernetes cluster"
}
variable "github_configuration" {
  type = object({
    organization_name = string
    repository_name   = string
    branch_name       = string
  })
  default     = null
  description = "configuration for github connection"
}
variable "flux_configuration" {
  type = object({
    version                 = optional(string, null)
    registry                = optional(string, null)
    additional_tolerations  = optional(list(string), [])
    kustomization_overrides = optional(string, null)
  })
  description = "configuration for flux2"
}
