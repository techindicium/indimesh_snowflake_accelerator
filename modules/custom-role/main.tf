resource "snowflake_account_role" "custom_role" {
  provider = snowflake.security_admin
  name     = var.custom_role_name
}

resource "snowflake_grant_account_role" "inherit_role_sysadmin" {
  count    = var.inherit_sysadmin == true ? 1 : 0
  provider = snowflake.sys_admin

  role_name        = snowflake_account_role.custom_role.name
  parent_role_name = "SYSADMIN"
}

resource "snowflake_grant_account_role" "inherit_role_securityadmin" {
  count    = var.inherit_sysadmin == true ? 1 : 0
  provider = snowflake.sys_admin

  role_name        = snowflake_account_role.custom_role.name
  parent_role_name = "SECURITYADMIN"
}
