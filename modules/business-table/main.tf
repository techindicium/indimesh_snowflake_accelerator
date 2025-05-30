terraform {
  required_providers {
    snowflake = {
      source                = "Snowflake-Labs/snowflake"
      version               = "0.98.0"
      configuration_aliases = [snowflake.sys_admin, snowflake.security_admin]
    }
    snowsql = {
      source                = "aidanmelen/snowsql"
      version               = "1.3.3"
      configuration_aliases = [snowsql.sys_admin, snowsql.security_admin]
    }
  }
}

# On tables_configure you can set the tables as a variable utilizing the schema name on the config.yaml -> SNOWPIPE schema_name.
locals {
    tables_configure = jsondecode(file("data/tables/${var.table_name}.json"))
    tables = [for table in local.tables_configure.tables : table]
}

resource "snowflake_table" "tables_json" {
    for_each = { for table in local.tables : table.name => table }
    provider = snowflake.sys_admin

    name = each.value.name
    database = var.database_name
    schema = each.value.name_schema

    dynamic "column" {
      for_each = each.value.columns
      content{
        name = column.value.name
        type = column.value.type
      }
    }
}