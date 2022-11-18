# SSH
locals {
  known_hosts = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="
  target_path = "clusters/${var.cluster_name}"
  flux_patches = {
    acr_image_reflector_controller = file("${path.module}/acr-image-reflector-controller-patch.yaml")
    helm_caching                   = file("${path.module}/helm-caching-patch.yaml")
    safe_to_evict                  = file("${path.module}/safe-to-evict-patch.yaml")
  }
}
resource "tls_private_key" "main" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}
