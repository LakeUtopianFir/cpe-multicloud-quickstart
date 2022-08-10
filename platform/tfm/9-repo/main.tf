resource "google_artifact_registry_repository" "my-repo" {
  count = var.repoexists ? 1 : 0
  location      = var.region
  project       = var.project
  repository_id = var.repoid
  description   = "Genesys container and helm chart repository"
  format        = "DOCKER"
}



resource "null_resource" "remoteregistrylogin" {
  # Login to remote registry
  provisioner "local-exec" {
    command = <<-EOT
      podman login -u ${var.remoteregistry_user} -p ${var.remoteregistry_pass} ${var.remoteregistry}
      helm repo add helm-multicloud ${var.remotehelm} --username ${var.remoteregistry_user} --password ${var.remoteregistry_pass} && helm repo update
    EOT
  }
}

resource "null_resource" "chart-pull" {
  # Pull charts
  for_each = var.charts
  provisioner "local-exec" {
    command = "helm pull helm-multicloud/${each.key} --version ${each.value}"
  }
  depends_on = [null_resource.remoteregistrylogin]
}

resource "null_resource" "chart-push" {
  # Push charts
  for_each = var.charts
  provisioner "local-exec" {
    command = "helm push ${each.key}-${each.value}.tgz oci://${var.region}-docker.pkg.dev/${var.project}/${var.repoid}"
  }
  depends_on = [null_resource.chart-pull]
}


resource "null_resource" "image-pull" {
  # Pull containers
  for_each = var.images
  provisioner "local-exec" {
    command = "podman pull ${var.remoteregistry}/${each.key}:${each.value}"
  }
  depends_on = [null_resource.remoteregistrylogin]
}

resource "null_resource" "image-tag" {
  # Tag containers
  for_each = var.images
  provisioner "local-exec" {
    command = "podman tag ${var.remoteregistry}/${each.key}:${each.value} ${var.region}-docker.pkg.dev/${var.project}/${var.repoid}/${each.key}:${each.value}"
  }
  depends_on = [null_resource.image-pull]
}

resource "null_resource" "image-push" {
  # Push containers
  for_each = var.images
  provisioner "local-exec" {
    command = "podman push ${var.region}-docker.pkg.dev/${var.project}/${var.repoid}/${each.key}:${each.value}"
  }
  depends_on = [null_resource.image-tag]
}