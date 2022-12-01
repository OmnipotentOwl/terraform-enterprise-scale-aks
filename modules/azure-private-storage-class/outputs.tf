output "standard_files_storage_class_name" {
  value = kubernetes_storage_class_v1.standard_files.metadata[0].name
}
output "premium_files_storage_class_name" {
  value = kubernetes_storage_class_v1.premium_files.metadata[0].name
}
output "premium_blobfuse_storage_class_name" {
  value = kubernetes_storage_class_v1.premium_blobfuse.metadata[0].name
}
output "premium_nfs_storage_class_name" {
  value = kubernetes_storage_class_v1.premium_nfs.metadata[0].name
}
output "standard_files_storage_account" {
  value = azurerm_storage_account.standard_files
}
output "premium_files_storage_account" {
  value = azurerm_storage_account.premium_files
}
output "premium_blobfuse_storage_account" {
  value = azurerm_storage_account.premium_blobfuse
}
output "premium_nfs_storage_account" {
  value = azurerm_storage_account.premium_nfs
}