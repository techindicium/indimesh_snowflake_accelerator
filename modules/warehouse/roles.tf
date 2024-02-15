# resource "snowflake_role" "database_role" {
#   provider = snowflake.security_admin
#   name     = var.database_role_name
# }

# resource "snowflake_role" "warehouse_role" {
#   provider = snowflake.security_admin
#   name     = var.warehouse_role_name
# }

# resource "snowflake_role" "team_role" {
#   provider = snowflake.security_admin
#   name     = var.team_role_name
# }

# resource "snowsql_exec" "grant_usage_and_select_to_database" {
#   provider = snowsql.account_admin
#   create {
#     statements = <<-EOT
#     USE ROLE ACCOUNTADMIN;
#     USE SECONDARY ROLE SECURITYADMIN;
#     GRANT USAGE ON DATABASE "${snowflake_database.database.name}" TO ROLE "${snowflake_role.database_role.name}";
#     GRANTE USAGE ON ALL SCHEMAS IN DATABASE "${snowflake_database.database.name}" TO ROLE "${snowflake_role.database_role.name}";
#     GRANT SELECT ON FUTURE TABLES IN DATABASE "${snowflake_database.database.name}" TO ROLE "${snowflake_role.database_role.name}";
#     EOT
#   }
#   delete {
#     statements = <<-EOT
#     USE ROLE ACCOUNTADMIN;
#     USE SECONDARY ROLE SECURITYADMIN;
#     REVOKE SELECT, USAGE ON DATABASE "${snowflake_database.database.name}" TO ROLE "${snowflake_role.database_role.name}";
#     REVOKE USAGE ON ALL SCHEMAS IN DATABASE "${snowflake_database.database.name}" TO ROLE "${snowflake_role.database_role.name}";
#     REVOKE SELECT ON FUTURE TABLES IN DATABASE "${snowflake_database.database.name}" TO ROLE "${snowflake_role.database_role.name}";
#     EOT
#   }
# }

# resource "snowsql_exec" "grant_all_privileges_to_schemas" {
#   provider = snowsql.account_admin
#   count    = var.env == "mart" ? 1 : 0
#   create {
#     statements = <<-EOT
#     USE ROLE ACCOUNTADMIN;
#     USE SECONDARY ROLE SECURITYADMIN;
#     GRANT ALL PRIVILEGES ON ALL SCHEMAS IN DATABASE "${snowflake_database.database.name}" TO ROLE "${snowflake_role.team_role.name}";
#     GRANT ALL PRIVILEGES ON FUTURE SCHEMAS IN DATABASE "${snowflake_database.database.name}" TO ROLE "${snowflake_role.team_role.name}";
#     EOT
#   }
#   delete {
#     statements = <<-EOT
#     USE ROLE ACCOUNTADMIN;
#     USE SECONDARY ROLE SECURITYADMIN;
#     REVOKE ALL PRIVILEGES ON ALL SCHEMAS IN DATABASE "${snowflake_database.database.name}" FROM ROLE "${snowflake_role.team_role.name}";
#     REVOKE ALL PRIVILEGES ON FUTURE SCHEMAS IN DATABASE "${snowflake_database.database.name}" TO ROLE "${snowflake_role.team_role.name}";
#     EOT
#   }
# }

# resource "snowsql_exec" "grant_all_privileges_to_tables" {
#   provider = snowsql.account_admin
#   count    = var.env == "mart" ? 0 : 1
#   create {
#     statements = <<-EOT
#     USE ROLE ACCOUNTADMIN;
#     USE SECONDARY ROLE SECURITYADMIN;
#     GRANT ALL PRIVILEGES ON FUTURE TABLES IN DATABASE "${snowflake_database.database.name}" TO ROLE "${snowflake_role.team_role.name}";
#     EOT
#   }
#   delete {
#     statements = <<-EOT
#     USE ROLE ACCOUNTADMIN;
#     USE SECONDARY ROLE SECURITYADMIN;
#     REVOKE ALL PRIVILEGES ON FUTURE TABLES IN DATABASE "${snowflake_database.database.name}" TO ROLE "${snowflake_role.team_role.name}";
#     EOT
#   }
# }

# resource "snowsql_exec" "inherit_role" {
#   provider = snowsql.account_admin
#   create {
#     statements = <<-EOT
#     USE ROLE ACCOUNTADMIN;
#     USE SECONDARY ROLE SECURITYADMIN;
#     GRANT ROLE "${snowflake_role.database_role.name}" TO ROLE "${snowflake_role.team_role.name}";
#     GRANT ROLE "${snowflake_role.warehouse_role.name}" TO ROLE "${snowflake_role.team_role.name}";
#     EOT
#   }
#   delete {
#     statements = <<-EOT
#     USE ROLE ACCOUNTADMIN;
#     USE SECONDARY ROLE SECURITYADMIN;
#     REVOKE ROLE "${snowflake_role.database_role.name}" FROM ROLE "${snowflake_role.team_role.name}";
#     REVOKE ROLE "${snowflake_role.warehouse_role.name}" FROM ROLE "${snowflake_role.team_role.name}";
#     EOT
#   }
#   depends_on = [
#     snowflake_warehouse_grant.warehouse_usage,
#     snowflake_database_grant.database_usage,
#     snowsql_exec.grant_usage_and_select_to_database
#   ]
# }