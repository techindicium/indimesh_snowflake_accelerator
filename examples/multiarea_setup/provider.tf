terraform {
  required_version = ">=1.2.9"
  backend "s3" {
    encrypt = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    snowsql = {
      source  = "aidanmelen/snowsql"
      version = "1.3.3"
      configuration_aliases = [snowsql.sys_admin, snowsql.security_admin]
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.70.0"
      configuration_aliases = [
        snowflake.storage_integration_role,
      ]      
    }
  }
}

provider "aws" {
  region = "us-east-2"
  profile = "training"
}

provider "snowsql" {
  alias     = "account_admin"
  role      = "ACCOUNTADMIN"
  warehouse = local.wh_terraform
}

provider "snowsql" {
  alias     = "sys_admin"
  role      = "SYSADMIN"
  warehouse = local.wh_terraform
}

provider "snowsql" {
  alias     = "security_admin"
  role      = "SECURITYADMIN"
  warehouse = local.wh_terraform
}

provider "snowflake" {
  alias = "sys_admin"
  role  = "SYSADMIN"
}

provider "snowflake" {
  alias = "security_admin"
  role  = "SECURITYADMIN"
}

provider "snowflake" {
  alias = "storage_integration_role"
  account = var.snowflake_account
  role    = var.snowflake_storage_integration_owner_role
}