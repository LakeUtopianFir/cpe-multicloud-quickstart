module "gsp-storage-bucket" {
    source                = "../../../tfm/3-gcp-posttasks/5-gsp-storage-bucket/"
    gspStorageBucketName  = "INSERT_VGSPSTORAGEBUCKET"
    location              = "INSERT_VGCPREGIONPRIMARY"
    project_id            = "INSERT_VGCPPROJECT"
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

terraform {
  backend "gcs" {
    bucket = "INSERT_VSTORAGEBUCKET"
    prefix = "gsp-storage"
  }
}