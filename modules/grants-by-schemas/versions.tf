terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
      version = "2.5.0" 
      configuration_aliases = [snowflake.sys_admin, snowflake.security_admin]
    }
  }
}
