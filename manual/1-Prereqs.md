# Summary
The steps outlined below will prepare the GCP project with the necessary Google API enablement, CloudBuild triggers, and Google Secrets. These are the only steps that need to be manually executed from your local workstation. Once these procedures are complete, Cloud Build is setup to take over and run the rest of the Terraform and Helm Charts automatically. 

## Install Terraform
If its not already installed on your local workstation, go ahead and install Terraform from [HashiCorp](https://www.terraform.io/downloads)

## Install Google Cloud CLI
If its not already install on your local workstation, go ahead and install the Google Cloud CLI package from [Google](https://cloud.google.com/sdk/docs/install)

## Fork/Copy the repo
Fork this repo to your own Github account (you can also copy it over manaully if desired). While you can Fork it to other providers such as Bitbucket, the assumption throughout this project is that Github is used. Using other GIT Providers will be at your own discretion and making the necessary modifications to Cloud Build, etc.

## Create a new Google Cloud Project
It is highly recommended to install MultiCloud Private Edition into its own dedicated Google Cloud Project, however, you may use an existing Google Cloud Project if desired. Please refer to this [GCP Document](https://cloud.google.com/resource-manager/docs/creating-managing-projects) on creating a new Google Cloud Project. 

## Log into Google Cloud
Log into your Google Cloud account and set the project. With the Google Cloud CLI installed on your workstation, open up your favorite terminal and input the following commands to authenticate the terminal with your Google Cloud account and project:

```
gcloud auth login

gcloud config set project PROJECT_NAME
```

## Update Terraform variables and inputs with GCP and environment information
The "main.tf" file within the "platform/terraform/1-prereqs" directory and sub-folders will need to be updated with your GCP and environment information

### 1.) Update "platform/terraform/1-prereqs/1-gcp/main.tf"

#### Objective
The Terraform files within this step will provision the chosen GCP Project with the necessary Google Cloud API's and Terraform State Storage Bucket. 

| main.tf Variable | Value to replace | Description |
| ----------- | ----------- | ----------- |
| storageBucketName | INSERT_STORAGEBUCKETNAME | Name of the Cloud Storage bucket to store the Terraform state files. This is a name you define and then use throughout the rest of the project. |
| location | INSERT_LOCATION | The primary GCP region. To get a list of all possible regions, please refer to this [GCP Document](https://cloud.google.com/compute/docs/regions-zones/viewing-regions-zones) |
| project_id | INSERT_PROJECTNAME | The logical name of the GCP project (do not use the GCP Project Number) |
| project | INSERT_PROJECTNAME | The logical name of the GCP project (do not use the GCP Project Number) |
| user   | INSERT_SERVICEACCOUNT | The service account specific to Cloud Build that will be used to execute the Cloud Build triggers. This service account is created automatically when the Cloud Build API is enabled. The service account name will always be in the following format:  GCP_PROJECT_NUMBER@cloudbuild.gserviceaccount.com. |

```
module "gcp" {
  source = "../../../tfm/1-prereqs/1-gcp/"
  storageBucketName = "INSERT_STORAGEBUCKETNAME"
  location = "INSERT_LOCATION"
  project_id = "INSERT_PROJECTNAME"
  user = "serviceAccount:INSERT_SERVICEACCOUNT@cloudbuild.gserviceaccount.com"
}

provider "google" {
  project = ""INSERT_PROJECTNAME"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.29.0"
    }
  }

  required_version = "= 1.2.6"
}
```

Within your terminal, set the directory to "/platform/terraform/1-prereqs/1-gcp" and then run the following commands to execute and provision the GCP project with Terraform:

```
terraform init

terraform apply
```

**NOTICE**

The Cloud Build API sometimes takes a few minutes to fully initialize, even after Terraform says its completed and enabled the specific API for Cloud Build. This Terraform job may error out with a "Error 400: Request contains an invalid argument." message. If this happens, wait a few minutes and re-run "Terraform Apply" and it should run successfully. 

### 2.) Authenticate Github to Cloud Build
The Terraform logic in the previous step, enables the necessary Google API's against the chosen Google Cloud project, including the Cloud Build API. The Github account where this repository is forked too will need to be authenticated with Cloud Build before the next steps can continue. Please follow the Cloud Build documentation to set up the necessary Github authentication: https://cloud.google.com/build/docs/automating-builds/github/connect-repo-github


### 3.) Update "platform/terraform/1-prereqs/2-cloudbuild/main.tf"

**NOTICE**

Before continuing onto this step, make sure you authenticated Github to Cloud Build. This procedure is outlined in step 2 and very important to have been completed before continuing.

#### Objective
The Terraform files within this step will setup the Google Cloud Build triggers that will be used to provision the rest of the GCP platform and Multicloud Private Edition services. 

| main.tf Variable | Value to replace | Description |
| ----------- | ----------- | ----------- |
| project_id | INSERT_PROJECTNAME | The logical name of the GCP project (do not use the GCP Project Number) |
| project | INSERT_PROJECTNAME | The logical name of the GCP project (do not use the GCP Project Number) |
| gkeregionprimary | INSERT_PRIMARYREGION | The primary GCP region. To get a list of all possible regions, please refer to this [GCP Document](https://cloud.google.com/compute/docs/regions-zones/viewing-regions-zones) |
| gkeregionsecondary | INSERT_SECONDARYEGION | The secondary GCP region. To get a list of all possible regions, please refer to this [GCP Document](https://cloud.google.com/compute/docs/regions-zones/viewing-regions-zones) |
| gkecluster | INSERT_GKECLUSTERNAME | The name of the GKE cluster | 
| FQDN | INSERT_FQDN | The root FQDN that will be used for DNS. Every MultiCloud Private Edition service will use this FQDN and create a subdomain address off of it. For example, the FQDN of "domain.com" is assigned as the value. When GAUTH is stood up, it's URL will be "gauth.domain.com" and a certficate is assigned by Cert-Manager. |
| emailaddress | INSERT_EMAILADDRESS | The email address of an administrater to assign to the Cloud DNS service that is provisioned | 
| storageBucketName | INSERT_STORAGEBUCKETNAME | Name of the Cloud Storage bucket to store the Terraform state files. This MUST be the same value from "1-prereqs" | 
| gspStorageBucketName | INSERT_GSPSTORAGEBUCKETNAME | Name of the Cloud Storage bucket to store GSP exports | 
| bucket | INSERT_STORAGEBUCKETNAME | Name of the Cloud Storage bucket to store the Terraform state files. This MUST be the same value from "1-prereqs" | 
| githubURL | INSERT_GITHUBURL | The Github URL containing the cloned/forked repository | 
| helmRepoURL | INSERT_PRIMARYREGION and INSERT_HELMURL | The URL/Connection string for the Helm Charts. If Google Artifact registry is going to be used, then the follow schema is used: oci://INSERT_PRIMARYREGION-docker.pkg.dev/PROJECT_NAME/genesys-multicloud-pe-charts | 
| containerRegistryURL | INSERT_PRIMARYREGION and INSERT_CONTAINERURL | The URL for the Container Registry storing the MultiCloud Private Edition images. If Google Artifact registry is going to be used,then the following schema is used: INSERT_PRIMARYREGION-docker.pkg.dev/INSERT_PROJECTNAME/genesys-multicloud-pe-images
| repoid | INSERT_HELMREPOID | Folder/Directory to store the Helm Charts |
| remotehelm | INSERT_ARTIFCTORYURL | The FQDN url of the Genesys JFROG Artifactory repository. Example: https://pureengageuse1.jfrog.io/artifactory/api/helm/helm-multicloud | 
| remoterepo | INSERT_ARTIFCTORYHELMPATH | The url to the images and charts inside the Genesys JFROG Artifactory repository. Example: pureengageuse1-docker-multicloud.jfrog.io | 
| remoteuser | INSERT_ARTIFACTORYUSER | The username granted for the Genesys JFROG Artifactory Account | 
| remotepass | INSERT_ARTIFACTORYPASSWORD | The password granted for the Genesys JFROG Artifactory Account | 


```
module "cloudbuild" {
  source = "../../tfm/1-prereqs/2-cloudbuild/"
  project_id = "INSERT_PROJECTNAME"
  gkeregionprimary = "INSERT_PRIMARYREGION"
  gkeregionsecondary = "INSERT_SECONDARYREGION"
  gkecluster = "INSERT_GKECLUSTERNAME"
  fqdn = "INSERT_EMAILADDRESS"
  emailaddress = "INSERT_EMAILADDRESS"
  storageBucketName = "INSERT_STORAGEBUCKETNAME"
  gspStorageBucketName = "INSERT_GSPSTORAGEBUCKETNAME"
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

  required_version = "= 1.2.6"
}

terraform {
  backend "gcs" {
    bucket = "INSERT_STORAGEBUCKETNAME"
    prefix = "base-state"
  }
}
```

Within your terminal, set the directory to "/platform/terraform/1-prereqs/2-cloudbuild" and then run the following commands to setup the GCP Cloud Build triggers:

```
terraform init

terraform apply
```

### 4.) Update "platform/terraform/1-prereqs/3-pe-secrets/main.tf"

#### Objective

**NOTICE**

**THIS SECTION IS VERY IMPORTANT....PLEASE TAKE YOUR TIME HERE!**

Throughout the provisioning process of the MultiCloud Private Edition stack, various credentials are created such as Database Accounts, API clients, etc. The Helm charts in this repository will create a pre-defined username, but the passwords that will be used are defined here. This job will create numerous Google Secret entries that contain the passwords for various services and future steps. 

| main.tf Variable | Value to replace | Description |
| ----------- | ----------- | ----------- |
| project | INSERT_PROJECTNAME | The logical name of the GCP project (do not use the Project Number) |
| region | INSERT_PRIMARYREGION | The primary GCP region. To get a list of all possible regions, please refer to this [GCP Document](https://cloud.google.com/compute/docs/regions-zones/viewing-regions-zones) |
| bucket | INSERT_STORAGEBUCKETNAME | Name of the Cloud Storage bucket to store the Terraform state files. This MUST be the same value from "1-prereqs" |
| gauth_pg_password | | Password for the GAUTH Postgres Database | 


```
module "pe-secrets_instance" {
    source           = "../../../tfm/1-prereqs/3-pe-secrets/"
    region           = "INSERT_PRIMARYREGION"
    gauth_pg_password = ""
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

  required_version = "= 1.2.6"
}

terraform {
  backend "gcs" {
    bucket = "INSERT_STORAGEBUCKETNAME"
    prefix = "pe-secrets"
  }
}
```

Within your terminal, set the directory to "/platform/terraform/1-prereqs/3-pe-secrets" and then run the following commands to create the Google Secrets:

```
terraform init

terraform apply
```

### 5.) Create PrivateEdition Cloud Build Builder image
Before the rest of the GCP platform can be provisioned, a custom Cloud Build builder image needs to be created. This image will contain the necessary tools, SDK's, etc to perform the rest of the provisioning tasks. 

A CloudBuild trigger called "0-Create-PrivateEdition-Builder" is created. Run this Cloud Build job to create the necessary Builder image.