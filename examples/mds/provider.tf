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

module "snowflake_mds" {
  for_each = local.config_mds_layer
  source   = "../modules/snowflake-base"

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
    snowflake.account_admin  = snowflake.account_admin
    snowsql.sys_admin        = snowsql.sys_admin
    snowsql.security_admin   = snowsql.security_admin
    snowsql.account_admin    = snowsql.account_admin
  }

  warehouse_name                      = each.value.warehouse_attributes.warehouse_name
  warehouse_size                      = each.value.warehouse_attributes.warehouse_size
  auto_suspend                        = each.value.warehouse_attributes.auto_suspend
  enable_query_acceleration           = each.value.warehouse_attributes.enable_query_acceleration
  max_cluster_count                   = each.value.warehouse_attributes.max_cluster_count
  max_concurrency_level               = each.value.warehouse_attributes.max_concurrency_level
  query_acceleration_max_scale_factor = each.value.warehouse_attributes.query_acceleration_max_scale_factor
  statement_queued_timeout_in_seconds = each.value.warehouse_attributes.statement_queued_timeout_in_seconds
  statement_timeout_in_seconds        = each.value.warehouse_attributes.statement_timeout_in_seconds
  scaling_policy                      = each.value.warehouse_attributes.scaling_policy
  warehouse_role_name                 = each.value.warehouse_attributes.warehouse_role_name
  database_name                       = each.value.data_sources[0].database_name
  database_role_name                  = each.value.data_sources[0].database_role_name
  team_role_name                      = each.value.data_sources[0].team_role_name
  create_optional_resource            = false
}