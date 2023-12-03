variable "storageBucketName" {
  type = string
  description = "Name of the bucket"
}

# https://cloud.google.com/storage/docs/locations#location-r
variable "location" {
  type = string
  description = "location of the bucket"
  #default     = "US"
}

variable "project_id" {
  type = string
  description = "Project ID within GCP"
}

variable "user" {
  type = string
  description = "User to add to IAM Role Binding"
}