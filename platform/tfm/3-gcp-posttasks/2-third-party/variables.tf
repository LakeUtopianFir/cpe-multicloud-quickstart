# cluster variables
variable "project" {
    type = string
    description = "Project Name"
}
variable "region" {
    type = string
    description = "GCP Region"
}
variable "cluster" {
    type = string
    description = "GKE Cluster"
}
variable "domain" {
    type = string
    description = "Domain of GKE cluster"
}

###
# Kafka
variable kafka_helm_version {
  type = string
  default = "0.6.1"
}
# Keda
variable keda_helm_version {
  type = string
  default = "2.6.2"
}
# Consul
variable consul_helm_version {
  type = string
  default = "0.41.0"
}
# MSSQL
variable mssql_helm_version {
  type = string
  default = "1.0.11"
}
# Prometheus
variable prometheus_helm_version {
  type = string
  default = "36.2.0"
}
