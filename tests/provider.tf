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
      version = "0.70.0"
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

module "snowflake_warehouses" {
  source = "../../modules/warehouse"

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
    snowflake.account_admin  = snowflake.account_admin
    snowsql.sys_admin        = snowsql.sys_admin
    snowsql.security_admin   = snowsql.security_admin
    snowsql.account_admin    = snowsql.account_admin
  }

  warehouse_name                      = local.warehouse_name
  warehouse_size                      = local.warehouse_size
  auto_suspend                        = local.auto_suspend
  enable_query_acceleration           = local.enable_query_acceleration
  max_cluster_count                   = local.max_cluster_count
  max_concurrency_level               = local.max_concurrency_level
  query_acceleration_max_scale_factor = local.query_acceleration_max_scale_factor
  statement_queued_timeout_in_seconds = local.statement_queued_timeout_in_seconds
  statement_timeout_in_seconds        = local.statement_timeout_in_seconds
  scaling_policy                      = local.scaling_policy
  database_name                       = local.database_name
  database_role_name                  = local.database_role_name
  warehouse_role_name                 = local.warehouse_role_name
  team_role_name                      = local.team_role_name
  schema_name                         = local.schema_name
  create_optional_resource            = true
}