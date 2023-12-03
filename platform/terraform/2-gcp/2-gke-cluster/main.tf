module "gke" {
    source                  = "../../../tfm/2-gcp/2-gke-cluster/"
    project_id              = "INSERT_VGCPPROJECT"
    environment             = "enviroment01"
    network_name            = "network01"
    region                  = "INSERT_VGCPREGIONPRIMARY"
    cluster                 = "INSERT_VGKECLUSTER"
    gke_version             = "1.22.11-gke.400" #Minumum version supported: 1.22.*
    release_channel         = "UNSPECIFIED" 
    secondary_pod_range     = "10.198.64.0/18"
    secondary_service_range = "10.198.16.0/20"
    gke_num_nodes           = "2"
    windows_node_pool       = false
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
        prefix = "gke-cluster-INSERT_VGKECLUSTER-INSERT_VGCPREGIONPRIMARY-state"
    }
}
