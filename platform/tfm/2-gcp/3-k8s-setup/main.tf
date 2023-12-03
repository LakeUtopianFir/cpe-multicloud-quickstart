resource "kubernetes_storage_class" "class" {
  metadata {
    name = "csi-standard-rwx"
  }
  storage_provisioner = "filestore.csi.storage.gke.io"
  reclaim_policy      = "Delete"
  allow_volume_expansion = "true"
  volume_binding_mode = "Immediate"
  parameters = {
    tier = "BASIC_HDD"
    reserved-ipv4-cidr = var.ipv4
    network = var.network_name
  }
}