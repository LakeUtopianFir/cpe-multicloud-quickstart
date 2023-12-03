variable "project_id" {
  type = string
  description = "Project ID within GCP"
}

variable "gkeregionprimary" {
  type        = string
  description = "Primary Region"
}

variable "gkeregionsecondary" {
  type        = string
  description = "Secondary Region"
}

variable "fqdn" {
  type        = string
  description = "FQDN for the Private Edition Apps"
}

variable "gkecluster" {
  type = string
  description = "GKE Cluster Name"
}

variable "emailaddress" {
  type = string
  description = "Email Address to use for DNS zone"
}

variable "storageBucketName" {
  type = string
  description = "Name of the Terraform Storage Bucket"
}

variable "gspStorageBucketName" {
  type = string
  description = "Name of the GSP Storage Bucket"
}

variable "githubURL" {
  type = string
  description = "URL of Github account"
}

variable "helmRepoURL" {
  type = string
  description = "URL of Helm Repo"
}

variable "containerRegistryURL" {
  type = string
  description = "URL of Container Registry"
}

variable "repoid" {
  type = string
  description = "URL of Container Registry"
}

variable "remoterepo" {
  type = string
  description = "URL of Container Registry"
}

variable "remoteuser" {
  type = string
  description = "URL of Container Registry"
}

variable "remotepass" {
  type = string
  description = "URL of Container Registry"
}

variable "remotehelm" {
  type = string
  description = "URL of Container Registry"
}