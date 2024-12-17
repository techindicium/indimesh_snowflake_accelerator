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

resource "snowflake_warehouse" "warehouse" {
  provider                            = snowflake.sys_admin
  name                                = var.warehouse_name
  warehouse_size                      = var.warehouse_size
  auto_resume                         = true
  auto_suspend                        = var.auto_suspend
  enable_query_acceleration           = var.enable_query_acceleration
  initially_suspended                 = true
  max_cluster_count                   = var.max_cluster_count
  max_concurrency_level               = var.max_concurrency_level
  min_cluster_count                   = var.max_cluster_count > 1 ? 1 : null
  query_acceleration_max_scale_factor = var.query_acceleration_max_scale_factor
  statement_queued_timeout_in_seconds = var.statement_queued_timeout_in_seconds
  statement_timeout_in_seconds        = var.statement_timeout_in_seconds
  scaling_policy                      = var.scaling_policy
}

module "warehouse_custom_role" {
  source = "../custom-role"

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin

    snowsql.sys_admin      = snowsql.sys_admin
    snowsql.security_admin = snowsql.security_admin
  }

  custom_role_name = "${var.warehouse_name}_ROL"
  depends_on = [
    snowflake_warehouse.warehouse
  ]
}

resource "snowflake_warehouse_grant" "warehouse_usage" {
  provider               = snowflake.security_admin
  warehouse_name         = snowflake_warehouse.warehouse.name
  privilege              = "USAGE"
  roles                  = [module.warehouse_custom_role.custom_role_name]
  with_grant_option      = false
  enable_multiple_grants = true
}

resource "snowsql_exec" "grant_warehouse_role_to_var_assigned_roles" {
  provider = snowsql.security_admin
  for_each   = {
    for index, role in var.assing_warehouse_role_to_roles:
    role => role
  }

  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    GRANT ROLE "${module.warehouse_custom_role.custom_role_name}" TO ROLE "${each.key}";
    EOT
  }
  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    REVOKE ROLE "${module.warehouse_custom_role.custom_role_name}" FROM ROLE "${each.key}";
    EOT
  }
}