variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}
variable "zonal_replication" {
  type        = bool
  description = "Enable zonal replication for the storage account"
  default     = false
}
variable "private_endpoint_subnet" {
  type = object({
    id                  = string
    name                = string
    resource_group_name = string
  })
  description = "(required) The subnet to create the private endpoint in"
}
variable "storage_resource_group" {
  type = object({
    id       = string
    name     = string
    location = string
  })
  description = "(required) The resource group to create the storage accounts in"
}
