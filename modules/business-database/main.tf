terraform {
  required_providers {
    snowflake = {
      source                = "Snowflake-Labs/snowflake"
      version               = "0.70.0"
      configuration_aliases = [snowflake.sys_admin, snowflake.security_admin]
    }
    snowsql = {
      source                = "aidanmelen/snowsql"
      version               = "1.3.3"
      configuration_aliases = [snowsql.sys_admin, snowsql.security_admin]
    }
  }
}

locals {
  db_name = upper(var.database_name)
}

resource "snowflake_database" "database" {
  provider                    = snowflake.sys_admin
  name                        = local.db_name
  is_transient                = false
  data_retention_time_in_days = var.data_retention_time_in_days
  comment                     = var.comment
}

# staging
# intermediate
resource "snowflake_schema" "marts_schema" {
  provider                    = snowflake.sys_admin
  name = "MARTS"
  database = snowflake_database.database.name
  data_retention_days = var.staging_schema_data_retention_days
}