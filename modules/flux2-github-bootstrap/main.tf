# SSH
locals {
  target_path            = "clusters/${var.cluster_name}"
  built_in_kustomization = file("${path.module}/kustomization.yaml")
}
resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}
