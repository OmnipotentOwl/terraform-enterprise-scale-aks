output "standard_files_storage_class_name" {
  value       = kubernetes_storage_class_v1.standard_files.metadata[0].name
  description = "standard azure files private storage class name"
}
output "premium_files_storage_class_name" {
  value       = kubernetes_storage_class_v1.premium_files.metadata[0].name
  description = "premium azure files private storage class name"
}
output "premium_blobfuse_storage_class_name" {
  value       = kubernetes_storage_class_v1.premium_blobfuse.metadata[0].name
  description = "premium azure blob private storage class name"
}
output "premium_nfs_storage_class_name" {
  value       = kubernetes_storage_class_v1.premium_nfs.metadata[0].name
  description = "premium azure nfs private storage class name"
}
output "standard_files_storage_account" {
  value       = azurerm_storage_account.standard_files
  description = "standard azure files private storage account"
}
output "premium_files_storage_account" {
  value       = azurerm_storage_account.premium_files
  description = "premium azure files private storage account"
}
output "premium_blobfuse_storage_account" {
  value       = azurerm_storage_account.premium_blobfuse
  description = "premium azure blob private storage account"
}
output "premium_nfs_storage_account" {
  value       = azurerm_storage_account.premium_nfs
  description = "premium azure nfs private storage account"
}
