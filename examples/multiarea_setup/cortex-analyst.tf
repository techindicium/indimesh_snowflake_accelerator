module "cortex_analyst_access" {
  for_each = toset(local.config.cortex_analyst_roles)
  source   = "../../snowflake-base/modules/cortex-analyst"

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
  }

  account_role = each.value
}
