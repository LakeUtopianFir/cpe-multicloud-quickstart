resource "google_secret_manager_secret" "GAUTH_POSTGRES_PASSWORD-secret" {
  secret_id = "GAUTH_POSTGRES_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GAUTH_POSTGRES_PASSWORD-secret-1" {
  secret      = google_secret_manager_secret.GAUTH_POSTGRES_PASSWORD-secret.id
  secret_data = var.GAUTH_POSTGRES_PASSWORD
}


resource "google_secret_manager_secret" "GAUTH_gauth_pg_password-secret" {
  secret_id = "GAUTH_gauth_pg_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GAUTH_gauth_pg_password-secret-1" {
  secret      = google_secret_manager_secret.GAUTH_gauth_pg_password-secret.id
  secret_data = var.GAUTH_gauth_pg_password
}

resource "google_secret_manager_secret" "VOICE_CONSUL_VOICE_TOKEN-secret" {
  secret_id = "VOICE_CONSUL_VOICE_TOKEN"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "VOICE_CONSUL_VOICE_TOKEN-secret-1" {
  secret      = google_secret_manager_secret.VOICE_CONSUL_VOICE_TOKEN-secret.id
  secret_data = var.VOICE_CONSUL_VOICE_TOKEN
}




resource "google_secret_manager_secret" "VOICE_POSTGRES_PASSWORD-secret" {
  secret_id = "VOICE_POSTGRES_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "VOICE_POSTGRES_PASSWORD-secret-1" {
  secret      = google_secret_manager_secret.VOICE_POSTGRES_PASSWORD-secret.id
  secret_data = var.VOICE_POSTGRES_PASSWORD
}

resource "google_secret_manager_secret" "VOICE_REDIS_PASSWORD-secret" {
  secret_id = "VOICE_REDIS_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "VOICE_REDIS_PASSWORD-secret-1" {
  secret      = google_secret_manager_secret.VOICE_REDIS_PASSWORD-secret.id
  secret_data = var.VOICE_REDIS_PASSWORD
}

resource "google_secret_manager_secret" "VOICE_tenant_gauth_client_secret-secret" {
  secret_id = "VOICE_tenant_gauth_client_secret"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "VOICE_tenant_gauth_client_secret-secret-1" {
  secret      = google_secret_manager_secret.VOICE_tenant_gauth_client_secret-secret.id
  secret_data = var.VOICE_tenant_gauth_client_secret
}

resource "google_secret_manager_secret" "VOICE_tenant_t100_pg_db_password-secret" {
  secret_id = "VOICE_tenant_t100_pg_db_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "VOICE_tenant_t100_pg_db_password-secret-1" {
  secret      = google_secret_manager_secret.VOICE_tenant_t100_pg_db_password-secret.id
  secret_data = var.VOICE_tenant_t100_pg_db_password
}

resource "google_secret_manager_secret" "GWS_gws_redis_password-secret" {
  secret_id = "GWS_gws_redis_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GWS_gws_redis_password-secret-1" {
  secret      = google_secret_manager_secret.GWS_gws_redis_password-secret.id
  secret_data = var.GWS_gws_redis_password
}

resource "google_secret_manager_secret" "GWS_gws_consul_token-secret" {
  secret_id = "GWS_gws_consul_token"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GWS_gws_consul_token-secret-1" {
  secret      = google_secret_manager_secret.GWS_gws_consul_token-secret.id
  secret_data = var.GWS_gws_consul_token
}

resource "google_secret_manager_secret" "GWS_POSTGRES_PASSWORD-secret" {
  secret_id = "GWS_POSTGRES_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GWS_POSTGRES_PASSWORD-secret-1" {
  secret      = google_secret_manager_secret.GWS_POSTGRES_PASSWORD-secret.id
  secret_data = var.GWS_POSTGRES_PASSWORD
}

resource "google_secret_manager_secret" "GWS_gws_pg_pass-secret" {
  secret_id = "GWS_gws_pg_pass"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GWS_gws_pg_pass-secret-1" {
  secret      = google_secret_manager_secret.GWS_gws_pg_pass-secret.id
  secret_data = var.GWS_gws_pg_pass
}

resource "google_secret_manager_secret" "GWS_gws_as_pg_pass-secret" {
  secret_id = GWS_gws_as_pg_pass"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GWS_gws_as_pg_pass-secret-1" {
  secret      = google_secret_manager_secret.GWS_gws_as_pg_pass-secret.id
  secret_data = var.GWS_gws_as_pg_pass
}

resource "google_secret_manager_secret" "GWS_gws_client_secret-secret" {
  secret_id = "GWS_gws_client_secret"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GWS_gws_client_secret-secret-1" {
  secret      = google_secret_manager_secret.GWS_gws_client_secret-secret.id
  secret_data = var.GWS_gws_client_secret
}

resource "google_secret_manager_secret" "GWS_ws_ops_pass_encr-secret" {
  secret_id = "GWS_ws_ops_pass_encr"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GWS_ws_ops_pass_encr-secret-1" {
  secret      = google_secret_manager_secret.GWS_ws_ops_pass_encr-secret.id
  secret_data = var.GWS_ws_ops_pass_encr
}


resource "google_secret_manager_secret" "UCWS_POSTGRES_PASSWORD-secret" {
  secret_id = "UCWS_POSTGRES_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "UCWS_POSTGRES_PASSWORD-secret-1" {
  secret      = google_secret_manager_secret.UCWS_POSTGRES_PASSWORD-secret.id
  secret_data = var.UCWS_POSTGRES_PASSWORD
}

resource "google_secret_manager_secret" "UCWS_ucsx_gauth_client_secret-secret" {
  secret_id = "UCWS_ucsx_gauth_client_secret"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "UCWS_ucsx_gauth_client_secret-secret-1" {
  secret      = google_secret_manager_secret.UCWS_ucsx_gauth_client_secret-secret.id
  secret_data = var.UCWS_ucsx_gauth_client_secret
}

resource "google_secret_manager_secret" "UCWS_ucsx_tenant_100_db_password-secret" {
  secret_id = "UCWS_ucsx_tenant_100_db_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "UCWS_ucsx_tenant_100_db_password-secret-1" {
  secret      = google_secret_manager_secret.UCWS_ucsx_tenant_100_db_password-secret.id
  secret_data = var.UCWS_ucsx_tenant_100_db_password
}

resource "google_secret_manager_secret" "TLM_TELEMETRY_AUTH_CLIENT_SECRET-secret" {
  secret_id = "TLM_TELEMETRY_AUTH_CLIENT_SECRET"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }

}

resource "google_secret_manager_secret_version" "TLM_TELEMETRY_AUTH_CLIENT_SECRET-secret-1" {
  secret      = google_secret_manager_secret.TLM_TELEMETRY_AUTH_CLIENT_SECRET-secret.id
  secret_data = var.TLM_TELEMETRY_AUTH_CLIENT_SECRET
}

resource "google_secret_manager_secret" "PULSE_POSTGRES_PASSWORD-secret" {
  secret_id = "PULSE_POSTGRES_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "PULSE_POSTGRES_PASSWORD-secret-1" {
  secret      = google_secret_manager_secret.PULSE_POSTGRES_PASSWORD-secret.id
  secret_data = var.PULSE_POSTGRES_PASSWORD
}

resource "google_secret_manager_secret" "PULSE_gws_Client_Secret-secret" {
  secret_id = "PULSE_gws_Client_Secret"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "PULSE_gws_Client_Secret-secret-1" {
  secret      = google_secret_manager_secret.PULSE_gws_Client_Secret-secret.id
  secret_data = var.PULSE_gws_Client_Secret
}

resource "google_secret_manager_secret" "PULSE_redis_key-secret" {
  secret_id = "PULSE_redis_key"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "PULSE_redis_key-secret-1" {
  secret      = google_secret_manager_secret.PULSE_redis_key-secret.id
  secret_data = var.PULSE_redis_key
}

resource "google_secret_manager_secret" "NEXUS_POSTGRES_PASSWORD-secret" {
  secret_id = "NEXUS_POSTGRES_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "NEXUS_POSTGRES_PASSWORD-secret-1" {
  secret      = google_secret_manager_secret.NEXUS_POSTGRES_PASSWORD-secret.id
  secret_data = var.NEXUS_POSTGRES_PASSWORD
}

resource "google_secret_manager_secret" "NEXUS_nexus_db_password-secret" {
  secret_id = "NEXUS_nexus_db_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "NEXUS_nexus_db_password-secret-1" {
  secret      = google_secret_manager_secret.NEXUS_nexus_db_password-secret.id
  secret_data = var.NEXUS_nexus_db_password
}

resource "google_secret_manager_secret" "NEXUS_nexus_gws_client_secret-secret" {
  secret_id = "NEXUS_nexus_gws_client_secret"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "NEXUS_nexus_gws_client_secret-secret-1" {
  secret      = google_secret_manager_secret.NEXUS_nexus_gws_client_secret-secret.id
  secret_data = var.NEXUS_nexus_gws_client_secret
}

resource "google_secret_manager_secret" "NEXUS_nexus_redis_password-secret" {
  secret_id = "NEXUS_nexus_redis_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "NEXUS_nexus_redis_password-secret-1" {
  secret      = google_secret_manager_secret.NEXUS_nexus_redis_password-secret.id
  secret_data = var.NEXUS_nexus_redis_password
}

resource "google_secret_manager_secret" "IXN_POSTGRES_PASSWORD-secret" {
  secret_id = "IXN_POSTGRES_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "IXN_POSTGRES_PASSWORD-secret-1" {
  secret      = google_secret_manager_secret.IXN_POSTGRES_PASSWORD-secret.id
  secret_data = var.IXN_POSTGRES_PASSWORD
}

resource "google_secret_manager_secret" "IXN_ixn_db_password-secret" {
  secret_id = "IXN_ixn_db_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "IXN_ixn_db_password-secret-1" {
  secret      = google_secret_manager_secret.IXN_ixn_db_password-secret.id
  secret_data = var.IXN_ixn_db_password
}

resource "google_secret_manager_secret" "IXN_redis_password-secret" {
  secret_id = "IXN_redis_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "IXN_redis_password-secret-1" {
  secret      = google_secret_manager_secret.IXN_redis_password-secret.id
  secret_data = var.IXN_redis_password
}

resource "google_secret_manager_secret" "IWDEM_iwdem_redis_password-secret" {
  secret_id = "IWDEM_iwdem_redis_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "IWDEM_iwdem_redis_password-secret-1" {
  secret      = google_secret_manager_secret.IWDEM_iwdem_redis_password-secret.id
  secret_data = var.IWDEM_iwdem_redis_password
}

resource "google_secret_manager_secret" "IWDEM_iwdem_nexus_api_key-secret" {
  secret_id = "dIWDEM_iwdem_nexus_api_key"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "IWDEM_iwdem_nexus_api_key-secret-1" {
  secret      = google_secret_manager_secret.IWDEM_iwdem_nexus_api_key-secret.id
  secret_data = var.IWDEM_iwdem_nexus_api_key
}

resource "google_secret_manager_secret" "IWDDM_POSTGRES_PASSWORD-secret" {
  secret_id = "IWDDM_POSTGRES_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "IWDDM_POSTGRES_PASSWORD-secret-1" {
  secret      = google_secret_manager_secret.IWDDM_POSTGRES_PASSWORD-secret.id
  secret_data = var.IWDDM_POSTGRES_PASSWORD
}

resource "google_secret_manager_secret" "IWDDM_gcxi_db_password-secret" {
  secret_id = "IWDDM_gcxi_db_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "IWDDM_gcxi_db_password-secret-1" {
  secret      = google_secret_manager_secret.IWDDM_gcxi_db_password-secret.id
  secret_data = var.IWDDM_gcxi_db_password
}

resource "google_secret_manager_secret" "IWDDM_gim_db_password-secret" {
  secret_id = "IWDDM_gim_db_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "IWDDM_gim_db_password-secret-1" {
  secret      = google_secret_manager_secret.IWDDM_gim_db_password-secret.id
  secret_data = var.IWDDM_gim_db_password
}

resource "google_secret_manager_secret" "IWDDM_iwddm_db_password-secret" {
  secret_id = "IWDDM_iwddm_db_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "IWDDM_iwddm_db_password-secret-1" {
  secret      = google_secret_manager_secret.IWDDM_iwddm_db_password-secret.id
  secret_data = var.IWDDM_iwddm_db_password
}

resource "google_secret_manager_secret" "IWDDM_iwddm_nexus_api_key-secret" {
  secret_id = "IWDDM_iwddm_nexus_api_key"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "IWDDM_iwddm_nexus_api_key-secret-1" {
  secret      = google_secret_manager_secret.IWDDM_iwddm_nexus_api_key-secret.id
  secret_data = var.IWDDM_iwddm_nexus_api_key
}

resource "google_secret_manager_secret" "GCXI_POSTGRES_PASSWORD-secret" {
  secret_id = "GCXI_POSTGRES_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GCXI_POSTGRES_PASSWORD-secret-1" {
  secret      = google_secret_manager_secret.GCXI_POSTGRES_PASSWORD-secret.id
  secret_data = var.GCXI_POSTGRES_PASSWORD
}

resource "google_secret_manager_secret" "GCXI_gim_db_pass-secret" {
  secret_id = "GCXI_gim_db_pass"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GCXI_gim_db_pass-secret-1" {
  secret      = google_secret_manager_secret.GCXI_gim_db_pass-secret.id
  secret_data = var.GCXI_gim_db_pass
}

resource "google_secret_manager_secret" "GCXI_iwd_db_pass-secret" {
  secret_id = "GCXI_iwd_db_pass"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GCXI_iwd_db_pass-secret-1" {
  secret      = google_secret_manager_secret.GCXI_iwd_db_pass-secret.id
  secret_data = var.GCXI_iwd_db_pass
}

resource "google_secret_manager_secret" "GCXI_GAUTH_KEY-secret" {
  secret_id = "GCXI_GAUTH_KEY"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GCXI_GAUTH_KEY-secret-1" {
  secret      = google_secret_manager_secret.GCXI_GAUTH_KEY-secret.id
  secret_data = var.GCXI_GAUTH_KEY
}






resource "google_secret_manager_secret" "GAUTH_pg_password-secret" {
  secret_id = "GAUTH_pg_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GAUTH_pg_password-secret-1" {
  secret      = google_secret_manager_secret.GAUTH_pg_password-secret.id
  secret_data = var.GAUTH_pg_password
}

resource "google_secret_manager_secret" "GAUTH_pg_password-secret" {
  secret_id = "GAUTH_pg_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GAUTH_redis_password-secret-1" {
  secret      = google_secret_manager_secret.GAUTH_redis_password-secret.id
  secret_data = var.GAUTH_redis_password
}

resource "google_secret_manager_secret" "GAUTH_redis_password-secret" {
  secret_id = "GAUTH_redis_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}


resource "google_secret_manager_secret_version" "GAUTH_admin_password-secret-1" {
  secret      = google_secret_manager_secret.GAUTH_admin_password-secret.id
  secret_data = var.GAUTH_admin_password
}

resource "google_secret_manager_secret" "GAUTH_admin_password-secret" {
  secret_id = "GAUTH_admin_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GAUTH_gws_client_secret-secret-1" {
  secret      = google_secret_manager_secret.GAUTH_gws_client_secret-secret.id
  secret_data = var.GAUTH_gws_client_secret
}

resource "google_secret_manager_secret" "GAUTH_gws_client_secret-secret" {
  secret_id = "GAUTH_gws_client_secret"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GAUTH_jks_keyPassword-secret-1" {
  secret      = google_secret_manager_secret.GAUTH_jks_keyPassword-secret.id
  secret_data = var.GAUTH_jks_keyPassword
}

resource "google_secret_manager_secret" "GAUTH_jks_keyPassword-secret" {
  secret_id = "GAUTH_jks_keyPassword"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GAUTH_jks_keyStorePassword-secret-1" {
  secret      = google_secret_manager_secret.GAUTH_jks_keyStorePassword-secret.id
  secret_data = var.GAUTH_jks_keyStorePassword
}

resource "google_secret_manager_secret" "GAUTH_jks_keyStorePassword-secret" {
  secret_id = "GAUTH_jks_keyStorePassword"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GVP_POSTGRES_PASSWORD-secret-1" {
  secret      = google_secret_manager_secret.GVP_POSTGRES_PASSWORD-secret.id
  secret_data = var.GVP_POSTGRES_PASSWORD
}

resource "google_secret_manager_secret" "GVP_POSTGRES_PASSWORD-secret" {
  secret_id = "GVP_POSTGRES_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GVP_cm_configserver_password-secret-1" {
  secret      = google_secret_manager_secret.GVP_cm_configserver_password-secret.id
  secret_data = var.GVP_cm_configserver_password
}

resource "google_secret_manager_secret" "GVP_cm_configserver_password-secret" {
  secret_id = "GVP_cm_configserver_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GVP_cm_pg_db_password-secret-1" {
  secret      = google_secret_manager_secret.GVP_cm_pg_db_password-secret.id
  secret_data = GVP_cm_pg_db_password
}

resource "google_secret_manager_secret" "GVP_cm_pg_db_password-secret" {
  secret_id = "GVP_cm_pg_db_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GVP_consul_token-secret-1" {
  secret      = google_secret_manager_secret.GVP_consul_token-secret.id
  secret_data = GVP_consul_token
}

resource "google_secret_manager_secret" "GVP_consul_token-secret" {
  secret_id = "GVP_consul_token"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GVP_rs_mssql_admin_password-secret-1" {
  secret      = google_secret_manager_secret.GVP_rs_mssql_admin_password-secret.id
  secret_data = GVP_rs_mssql_admin_password
}

resource "google_secret_manager_secret" "GVP_rs_mssql_admin_password-secret" {
  secret_id = "GVP_rs_mssql_admin_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GVP_rs_mssql_reader_password-secret-1" {
  secret      = google_secret_manager_secret.GVP_rs_mssql_reader_password-secret.id
  secret_data = GVP_rs_mssql_reader_password
}

resource "google_secret_manager_secret" "GVP_rs_mssql_reader_password-secret" {
  secret_id = "GVP_rs_mssql_reader_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GVP_rs_mssql_db_password-secret-1" {
  secret      = google_secret_manager_secret.GVP_rs_mssql_db_password-secret.id
  secret_data = GVP_rs_mssql_db_password
}

resource "google_secret_manager_secret" "GVP_rs_mssql_db_password-secret" {
  secret_id = "GVP_rs_mssql_db_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "CXC_POSTGRES_PASSWORD_password-secret-1" {
  secret      = google_secret_manager_secret.CXC_POSTGRES_PASSWORD_password-secret.id
  secret_data = CXC_POSTGRES_PASSWORD
}

resource "google_secret_manager_secret" "CXC_POSTGRES_PASSWORD_password-secret" {
  secret_id = "CXCPOSTGRES_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "CXC_redis_password_password-secret-1" {
  secret      = google_secret_manager_secret.CXC_redis_password_password-secret.id
  secret_data = CXC_redis_password
}

resource "google_secret_manager_secret" "CXC_redis_password_password-secret" {
  secret_id = "CXC_redis_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "CXC_configserver_user_password_password-secret-1" {
  secret      = google_secret_manager_secret.CXC_configserver_user_password_password-secret.id
  secret_data = CXC_configserver_user_password
}

resource "google_secret_manager_secret" "CXC_configserver_user_password_password-secret" {
  secret_id = "CXC_configserver_user_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "CXC_gws_client_secret_password-secret-1" {
  secret      = google_secret_manager_secret.CXC_gws_client_secret_password-secret.id
  secret_data = CXC_gws_client_secret
}

resource "google_secret_manager_secret" "CXC_gws_client_secret_password-secret" {
  secret_id = "CXC_gws_client_secret"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "CXC_prov_gwsauthpass_password-secret-1" {
  secret      = google_secret_manager_secret.CXC_prov_gwsauthpass_password-secret.id
  secret_data = CXC_prov_gwsauthpass
}

resource "google_secret_manager_secret" "CXC_prov_gwsauthpass_password-secret" {
  secret_id = "CXC_prov_gwsauthpass"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "CXC_prov_tenant_pass_password-secret-1" {
  secret      = google_secret_manager_secret.CXC_prov_tenant_pass_password-secret.id
  secret_data = CXC_prov_tenant_pass
}

resource "google_secret_manager_secret" "CXC_prov_tenant_pass_password-secret" {
  secret_id = "CXC_prov_tenant_pass"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "DESIGNER_gws_client_secret_password-secret-1" {
  secret      = google_secret_manager_secret.DESIGNER_gws_client_secret_password-secret.id
  secret_data = DESIGNER_gws_client_secret
}

resource "google_secret_manager_secret" "DESIGNER_gws_client_secret_password-secret" {
  secret_id = "DESIGNER_gws_client_secret"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GES_POSTGRES_PASSWORD_password-secret-1" {
  secret      = google_secret_manager_secret.GES_POSTGRES_PASSWORD_password-secret.id
  secret_data = GES_POSTGRES_PASSWORD
}

resource "google_secret_manager_secret" "GES_POSTGRES_PASSWORD_password-secret" {
  secret_id = "GES_POSTGRES_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GES_AUTHENTICATION_CLIENT_SECRET_password-secret-1" {
  secret      = google_secret_manager_secret.GES_AUTHENTICATION_CLIENT_SECRET_password-secret.id
  secret_data = GES_AUTHENTICATION_CLIENT_SECRET
}

resource "google_secret_manager_secret" "GES_AUTHENTICATION_CLIENT_SECRET_password-secret" {
  secret_id = "GES_AUTHENTICATION_CLIENT_SECRET"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GES_DB_PASSWORD_password-secret-1" {
  secret      = google_secret_manager_secret.GES_DB_PASSWORD_password-secret.id
  secret_data = GES_DB_PASSWORD
}

resource "google_secret_manager_secret" "GES_DB_PASSWORD_password-secret" {
  secret_id = "GES_DB_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GES_DEVOPS_PASSWORD_password-secret-1" {
  secret      = google_secret_manager_secret.GES_DEVOPS_PASSWORD_password-secret.id
  secret_data = GES_DEVOPS_PASSWORD
}

resource "google_secret_manager_secret" "GES_DEVOPS_PASSWORD_password-secret" {
  secret_id = "GES_DEVOPS_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GES_REDIS_ORS_PASSWORD_password-secret-1" {
  secret      = google_secret_manager_secret.GES_REDIS_ORS_PASSWORD_password-secret.id
  secret_data = GES_REDIS_ORS_PASSWORD
}

resource "google_secret_manager_secret" "GES_REDIS_ORS_PASSWORD_password-secret" {
  secret_id = "GES_REDIS_ORS_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GES_REDIS_PASSWORD_password-secret-1" {
  secret      = google_secret_manager_secret.GES_REDIS_PASSWORD_password-secret.id
  secret_data = GES_REDIS_PASSWORD
}

resource "google_secret_manager_secret" "GES_REDIS_PASSWORD_password-secret" {
  secret_id = "GES_REDIS_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GIM_POSTGRES_PASSWORD_password-secret-1" {
  secret      = google_secret_manager_secret.GIM_POSTGRES_PASSWORD_password-secret.id
  secret_data = GIM_POSTGRES_PASSWORD
}

resource "google_secret_manager_secret" "GIM_POSTGRES_PASSWORD_password-secret" {
  secret_id = "GIM_POSTGRES_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GIM_pgdb_etl_password_password-secret-1" {
  secret      = google_secret_manager_secret.GIM_pgdb_etl_password_password-secret.id
  secret_data = GIM_pgdb_etl_password
}

resource "google_secret_manager_secret" "GIM_pgdb_etl_password_password-secret" {
  secret_id = "GIM_pgdb_etl_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "GSP_SECRET_ACCESS_KEY_password-secret-1" {
  secret      = google_secret_manager_secret.GSP_SECRET_ACCESS_KEY_password-secret.id
  secret_data = GSP_SECRET_ACCESS_KEY
}

resource "google_secret_manager_secret" "GSP_SECRET_ACCESS_KEY_password-secret" {
  secret_id = "GSP_SECRET_ACCESS_KEY"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "IWD_POSTGRES_PASSWORD_password-secret-1" {
  secret      = google_secret_manager_secret.IWD_POSTGRES_PASSWORD_password-secret.id
  secret_data = IWD_POSTGRES_PASSWORD
}

resource "google_secret_manager_secret" "IWD_POSTGRES_PASSWORD_password-secret" {
  secret_id = "IWD_POSTGRES_PASSWORD"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "IWD_db_password_password-secret-1" {
  secret      = google_secret_manager_secret.IWD_db_password_password-secret.id
  secret_data = IWD_db_password
}

resource "google_secret_manager_secret" "IWD_db_password_password-secret" {
  secret_id = "IWD_db_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "IWD_redis_password_password-secret-1" {
  secret      = google_secret_manager_secret.IWD_redis_password_password-secret.id
  secret_data = IWD_redis_password
}

resource "google_secret_manager_secret" "IWD_redis_password_password-secret" {
  secret_id = "IWD_redis_password"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}

resource "google_secret_manager_secret_version" "IWD_gws_client_secret_password-secret-1" {
  secret      = google_secret_manager_secret.IWD_gws_client_secret_password-secret.id
  secret_data = IWD_gws_client_secret
}

resource "google_secret_manager_secret" "IWD_gws_client_secret_password-secret" {
  secret_id = "IWD_gws_client_secret"

  replication {
    user_managed {
      replicas {
        location = var.region 
      }
    }
  }
}