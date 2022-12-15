variable "cluster_name" {
  type        = string
  description = "name of the cluster to bootstrap in cloud provider"
}
variable "github_configuration" {
  type = object({
    organization_name = string
    repository_name   = string
    branch_name       = string
  })
  description = "configuration for github connection"
}
