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

resource "snowflake_role" "custom_role" {
  provider = snowflake.security_admin
  name     = var.custom_role_name
}

resource "snowsql_exec" "inherit_role" {
  count    = var.inherit_sysadmin == true ? 1 : 0
  provider = snowsql.security_admin
  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    GRANT ROLE "${snowflake_role.custom_role.name}" TO ROLE SYSADMIN;
    GRANT ROLE "${snowflake_role.custom_role.name}" TO ROLE SECURITYADMIN;
    EOT
  }
  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    REVOKE ROLE "${snowflake_role.custom_role.name}" FROM ROLE SYSADMIN;
    REVOKE ROLE "${snowflake_role.custom_role.name}" FROM ROLE SECURITYADMIN;
    EOT
  }
}