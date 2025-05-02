terraform {
  required_providers {
    snowflake = {
      source                = "Snowflake-Labs/snowflake"
      version               = "0.98.0"
      configuration_aliases = [snowflake.sys_admin, snowflake.security_admin]
    }
  }
}
