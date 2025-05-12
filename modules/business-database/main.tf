resource "snowflake_database" "database" {
  provider                    = snowflake.sys_admin
  name                        = var.database_name
  is_transient                = false
  data_retention_time_in_days = 7
  comment                     = var.comment
}

resource "snowflake_schema" "schema" {
  for_each = toset(local.schemas)
  provider = snowflake.sys_admin
  database = snowflake_database.database.name
  name     = each.value
  with_managed_access = true
  comment  = "${each.value} schema for ${var.database_name}"

  depends_on = [snowflake_database.database]
}
