module "custom_roles" {
  for_each = toset(local.config.roles)
  source = "../modules/custom-role"

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowsql.sys_admin        = snowsql.sys_admin
    snowflake.security_admin = snowflake.security_admin
    snowsql.security_admin   = snowsql.security_admin
  }

  custom_role_name = each.value
}
