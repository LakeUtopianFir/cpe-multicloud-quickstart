variable "region" {
    type = string
    description = "GCP Region"
}

variable "GAUTH_POSTGRES_PASSWORD" {
    type = string
    description = "Password GAUTH Service and POSTGRES_PASSWORD"
}

variable "GAUTH_gauth_pg_password" {
    type = string
    description = "Password GAUTH Service and gauth_pg_password"
}

variable "VOICE_CONSUL_VOICE_TOKEN" {
    type = string
    description = "Password for CONSUL_VOICE_TOKEN"
}

variable "VOICE_POSTGRES_PASSWORD" {
    type = string
    description = "Password for POSTGRES_PASSWORD"
}

variable "VOICE_REDIS_PASSWORD" {
    type = string
    description = "Password for REDIS_PASSWORD"
}

variable "VOICE_tenant_gauth_client_secret" {
    type = string
    description = "Password for tenant_gauth_client_secret"
}

variable "VOICE_tenant_t100_pg_db_password" {
    type = string
    description = "Password for tenant_t100_pg_db_password"
}

variable "GWS_gws_redis_password" {
    type = string
    description = "Password for gws_redis_password"
}

variable "GWS_gws_consul_token" {
    type = string
    description = "Password for gws_consul_token"
}

variable "GWS_POSTGRES_PASSWORD" {
    type = string
    description = "Password for POSTGRES_PASSWORD"
}

variable "GWS_gws_pg_pass" {
    type = string
    description = "Password for gws_pg_pass"
}

variable "GWS_gws_as_pg_pass" {
    type = string
    description = "Password for gws_as_pg_pass"
}

variable "GWS_gws_client_secret" {
    type = string
    description = "Password for gws_client_secret"
}

variable "GWS_ws_ops_pass_encr" {
    type = string
    description = "Password for gws_ops_pass_encr"
}

variable "UCWS_POSTGRES_PASSWORD" {
    type = string
    description = "Password for UCWS_POSTGRES_PASSWORD"
}

variable "UCWS_ucsx_gauth_client_secret" {
    type = string
    description = "Password for UCWS_ucsx_gauth_client_secret"
}

variable "UCWS_ucsx_tenant_100_db_password" {
    type = string
    description = "Password for UCWS_ucsx_tenant_100_db_password"
}

variable "TLM_TELEMETRY_AUTH_CLIENT_SECRET" {
    type = string
    description = "Password for TLM_TELEMETRY_AUTH_CLIENT_SECRET"
}

variable "PULSE_POSTGRES_PASSWORD" {
    type = string
    description = "Password for PLUSE_POSTGRES_PASSWORD"
}

variable "PULSE_gws_Client_Secret" {
    type = string
    description = "Password for PULSE_gws_Client_Secret"
}

variable "PULSE_redis_key" {
    type = string
    description = "Password for PULSE_redis_key"
}

variable "NEXUS_POSTGRES_PASSWORD" {
    type = string
    description = "Password for NEXUS_POSTGRES_PASSWORD"
}

variable "NEXUS_nexus_db_password" {
    type = string
    description = "Password for NEXUS_nexus_db_password"
}

variable "NEXUS_nexus_gws_client_secret" {
    type = string
    description = "Password for NEXUS_nexus_gws_client_secret"
}

variable "NEXUS_nexus_redis_password" {
    type = string
    description = "Password for NEXUS_nexus_redis_password"
}

variable "IXN_POSTGRES_PASSWORD" {
    type = string
    description = "Password for IXN_POSTGRES_PASSWORD"
}

variable "IXN_ixn_db_password" {
    type = string
    description = "Password for IXN_ixn_db_password"
}

variable "IXN_redis_password" {
    type = string
    description = "Password for IXN_redis_password"
}

variable "IWDEM_iwdem_redis_password" {
    type = string
    description = "Password for IWDEM_iwdem_redis_password"
}

variable "IWDEM_iwdem_nexus_api_key" {
    type = string
    description = "Password for IWDEM_iwdem_nexus_api_key"
}

variable "IWDDM_POSTGRES_PASSWORD" {
    type = string
    description = "Password for IWDDM_POSTGRES_PASSWORD"
}

variable "IWDDM_gcxi_db_password" {
    type = string
    description = "Password for IWDDM_gcxi_db_password"
}

variable "IWDDM_gim_db_password" {
    type = string
    description = "Password for IWDDM_gim_db_password"
}

variable "IWDDM_iwddm_db_password" {
    type = string
    description = "Password for IWDDM_iwddm_db_password"
}

variable "IWDDM_iwddm_nexus_api_key" {
    type = string
    description = "Password for IWDDM_iwddm_nexus_api_key"
}

variable "GCXI_POSTGRES_PASSWORD" {
    type = string
    description = "Password for GCXI_POSTGRES_PASSWORD"
}

variable "GCXI_gim_db_pass" {
    type = string
    description = "Password for GCXI_gim_db_pass"
}

variable "GCXI_iwd_db_pass" {
    type = string
    description = "Password for GCXI_iwd_db_pass"
}

variable "GCXI_GAUTH_KEY" {
    type = string
    description = "Password for GCXI_GAUTH_KEY"
}

variable "GAUTH_redis_password" {
    type = string
    description = "Password for gauth_redis_password"
}

variable "GAUTH_admin_password" {
    type = string
    description = "Password for gauth_admin_password"
}

variable "GAUTH_gws_client_secret" {
    type = string
    description = "Password for gauth_gws_client_secret"
}

variable "GAUTH_jks_keyPassword" {
    type = string
    description = "Password for gauth_jks_keyPassword"
}

variable "GAUTH_jks_keyStorePassword" {
    type = string
    description = "Password for gauth_jks_keyStorePassword"
}

variable "GVP_POSTGRES_PASSWORD" {
    type = string
    description = "Password for POSTGRES_PASSWORD"
}

variable "GVP_cm_configserver_password" {
    type = string
    description = "Password for gvp_cm_configserver_password"
}

variable "GVP_cm_pg_db_password" {
    type = string
    description = "Password for gvp_cm_pg_db_password"
}

variable "GVP_consul_token" {
    type = string
    description = "Password for gvp_consul_token"
}

variable "GVP_rs_mssql_admin_password" {
    type = string
    description = "Password for gvp_rs_mssql_admin_password"
}

variable "GVP_rs_mssql_reader_password" {
    type = string
    description = "Password for gvp_rs_mssql_reader_password"
}

variable "GVP_rs_mssql_db_password" {
    type = string
    description = "Password for gvp_rs_mssql_db_password"
}

variable "CXC_POSTGRES_PASSWORD" {
    type = string
    description = "Password for cxc_POSTGRES_PASSWORD"
}

variable "CXC_redis_password" {
    type = string
    description = "Password for cxc_redis_password"
}

variable "CXC_configserver_user_password" {
    type = string
    description = "Password for cxc_configserver_user_password"
}

variable "CXC_configserver_user_password" {
    type = string
    description = "Password for cxc_configserver_user_password"
}

variable "CXC_gws_client_secret" {
    type = string
    description = "Password for cxc_gws_client_secret"
}

variable "CXC_prov_gwsauthpass" {
    type = string
    description = "Password for cxc_prov_gwsauthpass"
}

variable "CXC_prov_tenant_pass" {
    type = string
    description = "Password for cxc_prov_tenant_pass"
}

variable "DESIGNERr_gws_client_secret" {
    type = string
    description = "Password for designer_gws_client_secret"
}

variable "GES_POSTGRES_PASSWORD" {
    type = string
    description = "Password for ges_POSTGRES_PASSWORD"
}

variable "GES_AUTHENTICATION_CLIENT_SECRET" {
    type = string
    description = "Password for ges_AUTHENTICATION_CLIENT_SECRET"
}

variable "GES_DB_PASSWORD" {
    type = string
    description = "Password for ges_DB_PASSWORD"
}

variable "GES_DEVOPS_PASSWORD" {
    type = string
    description = "Password for ges_DEVOPS_PASSWORD"
}

variable "GES_REDIS_ORS_PASSWORD" {
    type = string
    description = "Password for ges_REDIS_ORS_PASSWORD"
}

variable "GES_REDIS_PASSWORD" {
    type = string
    description = "Password for ges_REDIS_PASSWORD"
}

variable "GIM_POSTGRES_PASSWORD" {
    type = string
    description = "Password for gim_POSTGRES_PASSWORD"
}

variable "GIM_pgdb_etl_password" {
    type = string
    description = "Password for gim_pgdb_etl_password"
}

variable "GSP_SECRET_ACCESS_KEY" {
    type = string
    description = "Password for gsp_SECRET_ACCESS_KEY"
}

variable "IWD_POSTGRES_PASSWORD" {
    type = string
    description = "Password for iwd_POSTGRES_PASSWORD"
}

variable "IWD_db_password" {
    type = string
    description = "Password for iwd_db_password"
}

variable "IWD_redis_password" {
    type = string
    description = "Password for iwd_redis_password"
}

variable "IWD_gws_client_secret" {
    type = string
    description = "Password for iwd_gws_client_secret"
}