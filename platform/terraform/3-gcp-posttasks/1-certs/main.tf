module "ingress_certs" {
  source            = "../../../tfm/3-gcp-posttasks/1-ingress-certs/"
  project_id        = "INSERT_VGCPPROJECT"
  environment       = "INSERT_VGCPPROJECT"
  domain_name_nginx = "INSERT_VDOMAIN"
  email             = "INSERT_VEMAILADDRESS"
}

data "google_client_config" "provider" {}

data "google_container_cluster" "INSERT_VGKECLUSTER" {
  name = "INSERT_VGKECLUSTER"
  location = "INSERT_VGCPREGIONPRIMARY"
  project = "INSERT_VGCPPROJECT"
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
    prefix = "ingress-certs-INSERT_VGKECLUSTER-INSERT_VGCPREGIONPRIMARY-state"
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