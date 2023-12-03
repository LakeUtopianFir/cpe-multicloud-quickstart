### Consul vars
variable "consulsecret" {
    type        = string
    sensitive   = true
    description = "Consul bootstrap token"
}

### MSSQL vars
variable "mssqlsapassword" {
    type        = string
    sensitive   = true
    description = "Admin user's PWD for DB being created"
}