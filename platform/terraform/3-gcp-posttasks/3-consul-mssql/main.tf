module "consul-mssql-tasks" {
    source                = "../../../tfm/3-gcp-posttasks/3-consul-mssql/"
    project               = "INSERT_VGCPPROJECT"
    region                = "INSERT_VGCPREGIONPRIMARY"
}

terraform {
      required_providers {
        consul = {
          source = "hashicorp/consul"
          version = "2.15.1"
        }
        mssql = {
          source = "PGSSoft/mssql"
          version = "0.1.1"
        }
      }

  required_version = ">= 1.2.0, < 1.3.0"
}

provider "google" {
  project = "INSERT_VGCPPROJECT"
}

provider "consul" {
  address    = "localhost:8500"
  datacenter = "dc1"
  token      = var.consulsecret
}

provider "mssql" {
  hostname = "localhost"
  port     = 1433

  sql_auth = {
    username = "sa"
    password = var.mssqlsapassword
  }
}

terraform {
  backend "gcs" {
    bucket = "INSERT_VSTORAGEBUCKET"
    prefix = "consul-mssql-INSERT_VGKECLUSTER-INSERT_VGCPREGIONPRIMARY-state"
  }
}