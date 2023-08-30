resource "snowflake_warehouse" "warehouse" {
  provider                            = snowflake.account_admin
  name                                = var.warehouse_name
  warehouse_size                      = var.warehouse_size
  auto_resume                         = true
  auto_suspend                        = var.auto_suspend
  enable_query_acceleration           = var.enable_query_acceleration
  initially_suspended                 = true
  max_cluster_count                   = var.max_cluster_count
  max_concurrency_level               = var.max_concurrency_level
  min_cluster_count                   = var.max_cluster_count > 1 ? 1 : null
  query_acceleration_max_scale_factor = var.query_acceleration_max_scale_factor
  statement_queued_timeout_in_seconds = var.statement_queued_timeout_in_seconds
  statement_timeout_in_seconds        = var.statement_timeout_in_seconds
  scaling_policy                      = var.scaling_policy
}

resource "snowflake_database" "database" {
  provider                    = snowflake.account_admin
  name                        = var.database_name
  is_transient                = false
  data_retention_time_in_days = 0
}

resource "snowflake_schema" "schema" {
  provider            = snowflake.account_admin
  count               = var.create_optional_resource ? 1 : 0
  database            = snowflake_database.database.name
  name                = var.schema_name
  is_transient        = false
  is_managed          = false
  data_retention_days = 0
}


resource "snowflake_warehouse_grant" "warehouse_usage" {
  provider               = snowflake.security_admin
  warehouse_name         = snowflake_warehouse.warehouse.name
  privilege              = "USAGE"
  roles                  = [snowflake_role.warehouse_role.name]
  with_grant_option      = false
  enable_multiple_grants = false
}

resource "snowflake_database_grant" "database_usage" {
  provider               = snowflake.security_admin
  database_name          = snowflake_database.database.name
  privilege              = "USAGE"
  roles                  = [snowflake_role.database_role.name]
  with_grant_option      = false
  enable_multiple_grants = false
}