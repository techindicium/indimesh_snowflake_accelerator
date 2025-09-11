terraform {
  required_version = ">=1.2.9"

  required_providers {
    snowsql = {
      source                = "aidanmelen/snowsql"
      version               = "1.3.3"
      configuration_aliases = [snowsql.security_admin]
    }
    snowflake = {
      source = "snowflakedb/snowflake"
      version = "2.6.0"
      configuration_aliases = [snowflake.sys_admin]
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
