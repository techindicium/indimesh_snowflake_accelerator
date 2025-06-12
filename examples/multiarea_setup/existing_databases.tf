module "existing_databases" {
  source   = "../../modules/existing-database"
  for_each = local.config.existing_databases

  database_name       = each.value.database_name
  assign_bi_roles     = each.value.assign_manage_roles
  assign_create_roles = each.value.assign_create_roles
  assign_manage_roles = each.value.assign_manage_roles
  assign_select_roles = each.value.assign_select_roles

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
    snowsql.sys_admin        = snowsql.sys_admin
    snowsql.security_admin   = snowsql.security_admin
  }

}
