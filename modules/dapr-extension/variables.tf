variable "dapr_configuration_settings" {
  type        = any
  description = "The Dapr configuration settings to use for Dapr."
  default     = {}
}
variable "dapr_storage_class_name" {
  type        = string
  description = "The name of the storage class to use for Dapr."
  default     = "azurefile-csi"
}
variable "enable_zonal_replication" {
  type        = bool
  description = "Enable zonal replication for the storage account."
  default     = false
}
variable "enable_private_storage" {
  type        = bool
  description = "Enable private storage for Dapr."
  default     = false
}
variable "service_mesh_enabled" {
  type        = bool
  description = "Is service mesh enabled for Dapr."
  default     = false
}
variable "private_endpoint_subnet" {
  type = object({
    id                  = string
    name                = string
    resource_group_name = string
  })
  description = "The subnet to use for the private endpoint."
  default = {
    id                  = null
    name                = null
    resource_group_name = null
  }
}
variable "aks_cluster" {
  type = object({
    id                  = string
    name                = string
    resource_group_name = string
    location            = string
    node_resource_group = string
  })
  description = "The AKS cluster object to use for Dapr."
}
