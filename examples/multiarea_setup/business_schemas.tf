module "business_schemas" {
  depends_on = [module.business_databases, module.storage_integration]
  source     = "../../modules/business-schemas"
  for_each   = local.config.schemas

  schema_name         = each.value.schema_name
  database_name       = each.value.database_name
  file_format_name    = each.value.file_format_name
  file_format         = each.value.file_format
  url_s3              = each.value.url_stage
  stage_name          = each.value.stage_name
  storage_integration = var.storage_integration_name

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
    snowsql.security_admin   = snowsql.security_admin
    snowsql.sys_admin        = snowsql.sys_admin
  }
}
