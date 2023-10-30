# SSH
locals {
  target_path            = "clusters/${var.cluster_name}"
  built_in_kustomization = file("${path.module}/kustomization.yaml")
}
resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "random_id" "k8s_tracker" {
  byte_length = 8
  keepers = {
    k8s_cluster_host = var.kubernetes_configuration.host
    k8s_cluster_ca   = sensitive(var.kubernetes_configuration.cluster_ca_certificate)
    k8s_cluster_cert = sensitive(var.kubernetes_configuration.client_certificate)
  }
}
