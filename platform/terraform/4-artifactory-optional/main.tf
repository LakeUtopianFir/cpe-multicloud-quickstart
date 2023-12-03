module "artifactory_instance" {
    source                = "../../tfm/4-artifactory/"
    project               = "INSERT_VGCPPROJECT"
    region                = "INSERT_VGCPREGIONPRIMARY"
    repoid                = "INSERT_VGCPREPOID"
    imagerepoexists       = "INSERT_IMAGEREPOEXISTS"
    chartrepoexists       = "INSERT_CHARTSREPOEXISTS"
    remotehelm            = "INSERT_REMOTEHELM"
    remoteregistry        = "INSERT_REMOTEREPO"
    remoteregistry_user   = "INSERT_REMOTEUSER"
    remoteregistry_pass   = "INSERT_REMOTEPASS"
}

provider "google" {
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