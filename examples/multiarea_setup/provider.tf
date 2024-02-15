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
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.59.0"
    }
  }
}

provider "aws" {}

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
  alias = "account_admin"
  role  = "ACCOUNTADMIN"
}