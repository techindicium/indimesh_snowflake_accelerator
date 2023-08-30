resource "snowflake_role" "database_role" {
  provider = snowflake.security_admin
  name     = var.database_role_name
}

resource "snowflake_role" "warehouse_role" {
  provider = snowflake.security_admin
  name     = var.warehouse_role_name
}

resource "snowflake_role" "team_role" {
  provider = snowflake.security_admin
  name     = var.team_role_name
}