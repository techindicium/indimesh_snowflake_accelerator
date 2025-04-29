terraform {
  required_providers {
    snowflake = {
      source                = "Snowflake-Labs/snowflake"
      version               = "0.98.0"
      configuration_aliases = [snowflake.sys_admin, snowflake.security_admin]
    }
  }
}

module "project_data" {
  source = "../../../project_data"
}

locals {
  db_name = var.database_name
}

resource "snowflake_database" "database" {
  provider                    = snowflake.sys_admin
  name                        = local.db_name
  is_transient                = false
  data_retention_time_in_days = var.data_retention_time_in_days
  comment                     = var.comment
}

