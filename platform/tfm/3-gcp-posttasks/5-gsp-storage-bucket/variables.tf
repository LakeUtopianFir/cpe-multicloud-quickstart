variable "gspStorageBucketName" {
  type = string
  description = "Name of the bucket"
}

variable "location" {
  type = string
  description = "Region where the storage bucket resides"
}

variable "project_id" {
  type = string
  description = "Project ID within GCP"
}