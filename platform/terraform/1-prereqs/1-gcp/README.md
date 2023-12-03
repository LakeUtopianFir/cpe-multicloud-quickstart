
This example file can be used as follows. Additional details and list of required inputs can be found in the [module documentation](../../../tfm/0-remotestate/README.md)

1. Execute the following GCP commands from a terminal (That has the Google CLI/SDK installed)
    -  gcloud auth login
    -  gcloud config set project <project name>
    -  gcloud config set compute/region us-west2
    -  gcloud config set compute/zone us-west2-a
2. Execute with the terraform block commented out to create a bucket.
3. Uncomment the terraform block and move the statefile to the bucket using terraform prompts.

```hcl
module "cloudbuild" {
  source = "../../tfm/0-cloudbuild/"
  project_id = "gts-multicloud-pe-dev2"
  user = "serviceAccount:24743425028@cloudbuild.gserviceaccount.com" 
  storageBucketName = "gts-multicloud-pe-dev-tf-statefiles"
  location = "us-west2"
}

provider "google" {
  project = "gts-multicloud-pe-dev2"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
  }

  required_version = "= 1.0.11"
}
```