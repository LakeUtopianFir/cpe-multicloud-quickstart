variable "project" {
    type = string
    description = "Project Name"
}

variable "region" {
    type = string
    description = "GCP Region"
}

### MSSQL vars
variable "db_admin_name" {
    type        = string
    default     = "gkeadmin"
    description = "Admin user for DB being created"
}

variable "db_reader_name" {
    type        = string
    default     = "mssqlreader"
    description = "Read-only user for DB being created"
}

variable "db_admin_pass" {
    type        = string
    default     = "Genesys@123"
    sensitive   = true
    description = "Admin user's PWD for DB being created"
}

variable "db_reader_pass" {
    type        = string
    default     = "Genesys@123"
    sensitive   = true
    description = "Read-only user's PWD for DB being created"
}