module "network" {
    source          = "../../../tfm/2-gcp/1-network/"
    provision_vpc   = true
    project_id      = "INSERT_VGCPPROJECT"
    network_name    = "network01"
    environment     = "INSERT_VGCPPROJECT"
    region          = ["INSERT_VGCPREGIONPRIMARY","INSERT_VGCPREGIONSECONDARY"]
    fqdn            = "INSERT_VDOMAIN."

    subnets = [
        {
            subnet_name           = "enviroment01-INSERT_VGCPREGIONPRIMARY-subnet"
            subnet_ip             = "10.198.0.0/22"
            subnet_region         = "INSERT_VGCPREGIONPRIMARY"
        },
        {
            subnet_name           = "enviroment01-INSERT_VGCPREGIONPRIMARY-vm-subnet"
            subnet_ip             = "10.198.8.0/22"
            subnet_region         = "INSERT_VGCPREGIONPRIMARY"
        },
        {
            subnet_name           = "enviroment01-INSERT_VGCPREGIONPRIMARY-privateep-subnet"
            subnet_ip             = "10.198.4.0/22"
            subnet_region         = "INSERT_VGCPREGIONPRIMARY"
        },
         {
            subnet_name           = "enviroment01-INSERT_VGCPREGIONSECONDARY-subnet"
            subnet_ip             = "10.200.0.0/22"
            subnet_region         = "INSERT_VGCPREGIONSECONDARY"
        },
        {
            subnet_name           = "enviroment01-INSERT_VGCPREGIONSECONDARY-vm-subnet"
            subnet_ip             = "10.200.8.0/22"
            subnet_region         = "INSERT_VGCPREGIONSECONDARY"
        },
        {
            subnet_name           = "enviroment01-INSERT_VGCPREGIONSECONDARY-privateep-subnet"
            subnet_ip             = "10.200.4.0/22"
            subnet_region         = "INSERT_VGCPREGIONSECONDARY"
        }
    ]
}

provider "google" {
  project = "INSERT_VGCPPROJECT"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.29.0"
    }
  }

  required_version = ">= 1.2.0, < 1.3.0"
}

terraform {
  backend "gcs" {
    bucket = "INSERT_VSTORAGEBUCKET"
    prefix = "network-state"
  }
}