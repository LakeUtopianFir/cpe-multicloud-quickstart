module "third-party" {
    source  = "../../../tfm/3-gcp-posttasks/2-third-party/"
    project               = "INSERT_VGCPPROJECT"
    region                = "INSERT_VGCPREGIONPRIMARY"
    cluster               = "INSERT_VGKECLUSTER"
    domain                = "INSERT_VDOMAIN"
}

data "google_client_config" "provider" {}

data "google_container_cluster" "INSERT_VGKECLUSTER" {
  name     = "INSERT_VGKECLUSTER"
  location = "INSERT_VGCPREGIONPRIMARY"
  project  = "INSERT_VGCPPROJECT"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.29.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.6.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }

  required_version = ">= 1.2.0, < 1.3.0"
}

terraform {
    backend "gcs" {
        bucket = "INSERT_VSTORAGEBUCKET"
        prefix = "thirdparty-INSERT_VGKECLUSTER-INSERT_VGCPREGIONPRIMARY-state"
    }
}

provider "google" {
  project = "INSERT_VGCPPROJECT"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    # host  = "https://${data.google_container_cluster.INSERT_VGKECLUSTER.endpoint}"
    config_path = "~/.kube/config"
  }
}