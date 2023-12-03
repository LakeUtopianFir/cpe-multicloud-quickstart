module "k8s-setup" {
    source        = "../../../tfm/2-gcp/3-k8s-setup/"
    project_id   = "INSERT_VGCPPROJECT"
    network_name = "network01"
    ipv4         = "10.198.12.0/22"
}

data "google_client_config" "provider" {}

data "google_container_cluster" "INSERT_VGKECLUSTER" {
  name = "INSERT_VGKECLUSTER"
  location = "INSERT_VGCPREGIONPRIMARY"
  project = "INSERT_VGCPPROJECT"
}

provider "google" {
  project = "INSERT_VGCPPROJECT"
}

provider "kubernetes" {
  host = "https://${data.google_container_cluster.INSERT_VGKECLUSTER.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.INSERT_VGKECLUSTER.master_auth[0].cluster_ca_certificate,
  ) 
}

variable "helm_version" {
default = "v2.9.1"
}

provider "helm" {
  kubernetes {
    host = "https://${data.google_container_cluster.INSERT_VGKECLUSTER.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
    data.google_container_cluster.INSERT_VGKECLUSTER.master_auth[0].cluster_ca_certificate,
    )
    config_path = "~/.kube/config"
  } 
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.29.0"
    }
  }

  required_version = ">= 1.2.0, < 1.3.0"
}

terraform {
  backend "gcs" {
    bucket = "INSERT_VSTORAGEBUCKET" 
    prefix = "k8s-setup-INSERT_VGKECLUSTER-INSERT_VGCPREGIONPRIMARY-state"
  }
}