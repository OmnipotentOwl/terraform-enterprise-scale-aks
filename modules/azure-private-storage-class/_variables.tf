variable "cluster_name" {
  type = string
}
variable "zonal_replication" {
  type    = bool
  default = false
}
variable "private_endpoint_subnet" {
  type = object({
    id                  = string
    name                = string
    resource_group_name = string
  })
}
variable "storage_resource_group" {
  type = object({
    id       = string
    name     = string
    location = string
  })
}