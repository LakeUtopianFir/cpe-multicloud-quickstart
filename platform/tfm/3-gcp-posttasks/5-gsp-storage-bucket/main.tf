resource "google_storage_bucket" "gsp-storage" {
  name      = var.gspStorageBucketName
  location  = var.location
  uniform_bucket_level_access = true
  project = var.project_id

  versioning {
    enabled = false
  }
}

data "google_compute_default_service_account" "default" {
}


resource "google_storage_hmac_key" "gsp-storage-key" {
  service_account_email = data.google_compute_default_service_account.default.email
}

resource "google_secret_manager_secret" "gsp-storage-secret" {
  secret_id = "GSP_SECRET_ACCESS_KEY"

  replication {
    user_managed {
      replicas {
        location = var.location 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "gsp-storage-secret-1" {
  secret      = google_secret_manager_secret.gsp-storage-secret.id
  secret_data = google_storage_hmac_key.gsp-storage-key.secret
}

resource "google_secret_manager_secret" "gsp-storage-access-key" {
  secret_id = "GSP_ACCESS_KEY_ID"

  replication {
    user_managed {
      replicas {
        location = var.location 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "gsp-storage-access-key-1" {
  secret      = google_secret_manager_secret.gsp-storage-access-key.id
  secret_data = google_storage_hmac_key.gsp-storage-key.access_id
}