terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
      version = "2.6.0"
      configuration_aliases = [snowflake.sys_admin, snowflake.security_admin]
    }
    snowsql = {
      source                = "aidanmelen/snowsql"
      version               = "1.3.3"
      configuration_aliases = [snowsql.sys_admin, snowsql.security_admin]
    }
  }
}
