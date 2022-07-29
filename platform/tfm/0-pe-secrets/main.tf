resource "google_secret_manager_secret" "gauth_pg_password-secret" {
  secret_id = "GAUTH_gauth_pg_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "gauth_pg_password-secret-1" {
  secret      = google_secret_manager_secret.guath_pg_password-secret.id
  secret_data = var.gauth_pg_password
}