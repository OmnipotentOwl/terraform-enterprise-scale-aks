variable "cluster_id" {
  description = "The ID of the Kubernetes cluster to enable monitoring for"
  type        = string
}
variable "clsuter_name" {
  description = "The name of the Kubernetes cluster to enable monitoring for"
  type        = string
}
variable "clsuter_resource_group_name" {
  description = "The resource group name of the Kubernetes cluster to enable monitoring for"
  type        = string
}
variable "azure_monitor_workspace_id" {
  description = "The ID of the Azure Monitor Log Analytics workspace to send monitoring data to"
  type        = string
}
variable "azure_montior_workspace_location" {
  description = "The location of the Azure Monitor Log Analytics workspace to send monitoring data to"
  type        = string
}
