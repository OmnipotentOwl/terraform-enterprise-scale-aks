locals {
  standard_files_storage_account_suffix   = "aksfss${random_string.storage_account_name_seed.result}"
  premium_files_storage_account_suffix    = "aksfsp${random_string.storage_account_name_seed.result}"
  premium_blobfuse_storage_account_suffix = "aksbfp${random_string.storage_account_name_seed.result}"
  premium_nfs_storage_account_suffix      = "aksbnp${random_string.storage_account_name_seed.result}"
}

resource "random_string" "storage_account_name_seed" {
  length      = 16
  special     = false
  upper       = false
  min_lower   = 4
  min_numeric = 3

  keepers = {
    cluster_name = var.cluster_name
  }
}
