resource "snowflake_grant_database_role" "this" {
  database_role_name = "SNOWFLAKE.CORTEX_USER"
  parent_role_name   = var.account_role
}