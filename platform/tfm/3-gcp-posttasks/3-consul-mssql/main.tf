# Provider needs to be declared because it is non-hashicorp
terraform {
  required_providers {
    mssql = {
      source = "PGSSoft/mssql"
      version = "0.1.1"
    }
  }
}

### Create consul intentation to allow all-to-all connectivity
resource "consul_config_entry" "service_intentions" {
      name = "*"
      kind = "service-intentions"
      config_json = jsonencode({
        Sources = [
          {
            Name: "*",
            Action: "allow",
            Precedence: 5,
            Type: "consul"
          }
        ]
      })
    }

### Create MSSQL gvp_rs DB and users/logins
# Will fail if DB or LOGIN or USER exists
resource "mssql_database" "gvp_rs" {
  name      = "gvp_rs"
}

resource "mssql_sql_login" "admin" {
  name                      = var.db_admin_name
  password                  = var.db_admin_pass
  must_change_password      = false
  default_language          = "english"
  check_password_expiration = false
  check_password_policy     = false
}

resource "mssql_sql_login" "reader" {
  name                      = var.db_reader_name
  password                  = var.db_reader_pass
  must_change_password      = false
  default_language          = "english"
  check_password_expiration = false
  check_password_policy     = false
}

resource "mssql_sql_user" "dbo" {
  name        = var.db_admin_name
  database_id = mssql_database.gvp_rs.id
  login_id    = mssql_sql_login.admin.id
  depends_on = [mssql_database.gvp_rs,mssql_sql_login.admin]
}

resource "mssql_sql_user" "reader" {
  name        = var.db_reader_name
  database_id = mssql_database.gvp_rs.id
  login_id    = mssql_sql_login.reader.id
  depends_on = [mssql_database.gvp_rs,mssql_sql_login.reader]
}

data "mssql_database_role" "db_owner" {
  name        = "db_owner"
  database_id = mssql_database.gvp_rs.id
  depends_on = [mssql_database.gvp_rs]
}

data "mssql_database_role" "db_datareader" {
  name        = "db_datareader"
  database_id = mssql_database.gvp_rs.id
  depends_on = [mssql_database.gvp_rs]
}

resource "mssql_database_role_member" "db_owner" {
  role_id     = data.mssql_database_role.db_owner.id
  member_id   = mssql_sql_user.dbo.id
  depends_on  = [mssql_database.gvp_rs,mssql_sql_user.dbo]
}

resource "mssql_database_role_member" "db_datareader" {
  role_id     = data.mssql_database_role.db_datareader.id
  member_id   = mssql_sql_user.reader.id
  depends_on  = [mssql_database.gvp_rs,mssql_sql_user.reader]
}