module "jumphost_instance" {
    source                = "../../../tfm/10-misc/"
    project               = "INSERT_VGCPPROJECT"
    consultoken           = "INSERT_CONSUL_TOKEN"
    region                = "INSERT_VGCPREGIONPRIMARY"
}

terraform {
      required_providers {
        consul = {
          source = "hashicorp/consul"
          version = "2.15.1"
        }
      }

  required_version = "= 1.2.5"
}

provider "google" {
  project = "INSERT_VGCPPROJECT"
}

provider "consul" {
  address    = "localhost:8500"
  datacenter = "dc1"
  token      = "INSERT_CONSUL_TOKEN"
}