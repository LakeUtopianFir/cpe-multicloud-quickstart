resource "google_service_account" "docker-pull-service-account" {
  account_id   = "docker-pull"
  display_name = "docker-pull"
  project = var.project_id
}

resource "google_project_iam_member" "docker-pull-service-account-IAM" {
  project            = var.project_id
  role               = "roles/artifactregistry.reader"
  member             = "serviceAccount:${google_service_account.docker-pull-service-account.email}"
}

resource "google_service_account_key" "docker-pull-service-account-KEY" {
  service_account_id = google_service_account.docker-pull-service-account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_secret_manager_secret" "docker-pull-secret" {
  secret_id = "docker-pull-secret"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "docker-pull-secret-1" {
  secret      = google_secret_manager_secret.docker-pull-secret.id
  secret_data = google_service_account_key.docker-pull-service-account-KEY.private_key
}