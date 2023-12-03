module "gcp" {
  source = "../../../tfm/1-prereqs/1-gcp/"
  storageBucketName = "INSERT_STORAGEBUCKETNAME"
  location = "INSERT_LOCATION"
  project_id = "INSERT_PROJECTNAME"
  user = "serviceAccount:INSERT_SERVICEACCOUNT@cloudbuild.gserviceaccount.com"
}

provider "google" {
  project = "INSERT_PROJECTNAME"
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