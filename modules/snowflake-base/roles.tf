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

resource "snowsql_exec" "grant_all_privileges_to_database" {
  provider = snowsql.account_admin
  create {
    statements = <<-EOT
    GRANT ALL PRIVILEGES ON DATABASE "${snowflake_database.database.name}" TO "${snowflake_role.database_role.name}";
    EOT
  }
  delete {
    statements = <<-EOT
    REVOKE ALL PRIVILEGES ON DATABASE "${snowflake_database.database.name}" FROM "${snowflake_role.database_role.name}";
    EOT
  }
}

resource "snowsql_exec" "role_inheritance" {
  provider = snowsql.account_admin
  count    = var.create_optional_resource ? 1 : 0
  create {
    statements = <<-EOT
    GRANT ROLE "${snowflake_role.database_role.name}" TO ROLE "${snowflake_role.team_role.name}";
    GRANT ROLE "${snowflake_role.warehouse_role.name}" TO ROLE "${snowflake_role.team_role.name}";
    EOT
  }
  delete {
    statements = <<-EOT
    REVOKE ROLE "${snowflake_role.database_role.name}" FROM ROLE "${snowflake_role.team_role.name}";
    REVOKE ROLE "${snowflake_role.warehouse_role.name}" FROM ROLE "${snowflake_role.team_role.name}";
    EOT
  }
  depends_on = [
    snowflake_warehouse_grant.warehouse_usage,
    snowflake_database_grant.database_usage,
    snowsql_exec.grant_all_privileges_to_database
  ]
}