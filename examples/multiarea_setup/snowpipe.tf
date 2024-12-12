module "snowpipe" {
    depends_on = [ module.business_table]
    source = "../../modules/snowpipe"
    for_each = local.config.snowpipe

schema_name = each.value.schema_name
database_name = each.value.database_name
pipe_name = each.value.pipe_name
table_name = each.value.table_name
stage_name = each.value.stage_name
sns_topic = module.storage_integration.sns_topic_arn


 providers = {
    snowflake.sys_admin = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
    snowsql.security_admin = snowsql.security_admin
    snowsql.sys_admin = snowsql.sys_admin
  }
}