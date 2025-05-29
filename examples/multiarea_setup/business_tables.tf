module "business_table" {
  depends_on = [module.business_schemas]
  source     = "../../modules/business-table"
  for_each   = local.config.snowpipe

  table_name = each.value.table_name

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
    snowsql.security_admin   = snowsql.security_admin
    snowsql.sys_admin        = snowsql.sys_admin
  }
}
