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

resource "snowflake_pipe" "pipe" {
    provider                    = snowflake.sys_admin
    database                    = var.database_name
    schema                      = var.schema_name
    name                        = var.pipe_name
    copy_statement              = "copy into ${var.database_name}.${var.schema_name}.${var.table_name} from @${var.database_name}.${var.schema_name}.${var.stage_name} match_by_column_name = CASE_INSENSITIVE;"
    auto_ingest    = true
    aws_sns_topic_arn = var.sns_topic
}