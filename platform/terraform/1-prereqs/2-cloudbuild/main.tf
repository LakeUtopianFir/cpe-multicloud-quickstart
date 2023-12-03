module "cloudbuild" {
  source = "../../../tfm/1-prereqs/2-cloudbuild/"
  project_id = "INSERT_PROJECTNAME"
  gkeregionprimary = "INSERT_PRIMARYREGION"
  gkeregionsecondary = "INSERT_SECONDARYREGION"
  gkecluster = "INSERT_GKECLUSTERNAME"
  fqdn = "INSERT_FQDN"
  emailaddress = "INSERT_EMAILADDRESS"
  storageBucketName = "INSERT_STORAGEBUCKETNAME"
  gspStorageBucketName = "INSERT_GSPSTORAGEBUCKET"
  githubURL = "INSERT_GITHUBURL"
  helmRepoURL = "oci://INSERT_PRIMARYREGION-docker.pkg.dev/INSERT_PROJECTNAME/genesys-multicloud-pe-charts"
  containerRegistryURL = "INSERT_PRIMARYREGION-docker.pkg.dev/INSERT_PROJECTNAME/genesys-multicloud-pe-images"
  repoid = "INSERT_HELMREPOID"
  remotehelm = "INSERT_ARTIFCTORYURL" 
  remoterepo = "INSERT_ARTIFCTORYHELMPATH"
  remoteuser = "INSERT_ARTIFACTORYUSER"
  remotepass = "INSERT_ARTIFACTORYPASSWORD"
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

terraform {
  backend "gcs" {
    bucket = "INSERT_STORAGEBUCKETNAME"
    prefix = "base-state"
  }
}