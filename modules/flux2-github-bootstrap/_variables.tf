variable "cluster_type" {
  type    = string
  default = "aks"
}
variable "cluster_name" {
  type = string
}
variable "github_configuration" {
  type = object({
    organization_name = string
    repository_name   = string
    branch_name       = string
  })
}