module "grants_by_schemas" {
  source = "../../modules/grants-by-schemas"
  for_each = local.config.grants_by_schemas

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
  }

  database_name = each.value.database_name
  schemas       = each.value.schemas

  depends_on = [module.business_databases]
}
