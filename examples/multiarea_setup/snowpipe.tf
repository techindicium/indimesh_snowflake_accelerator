module "snowpipe" {
  depends_on = [module.business_table]
  source     = "../../modules/snowpipe"
  for_each   = local.config.snowpipe

  schema   = each.value.schema_name
  database = each.value.database_name
  name     = each.value.pipe_name

  copy_statement = <<-EOT
        COPY INTO ${each.value.database_name}.${each.value.schema_name}.${each.value.table_name}
        FROM @${each.value.database_name}.${each.value.schema_name}.${each.value.stage_name}
        FILE_FORMAT = (TYPE = PARQUET)
        MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
    EOT

  # If using an SNS topic, its mandatory to set `auto_ingest = true`
  aws_sns_topic_arn = var.aws_sns_topic_arn
  auto_ingest       = false

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
    snowsql.security_admin   = snowsql.security_admin
    snowsql.sys_admin        = snowsql.sys_admin
  }
}
