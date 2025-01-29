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

resource "snowflake_grant_privileges_to_account_role" "warehouse_usage" {
  provider               = snowflake.security_admin
  privileges             = ["USAGE"]
  account_role_name      = module.warehouse_custom_role.custom_role_name
  with_grant_option      = false
  on_account_object {
    object_type          = "WAREHOUSE"
    object_name          = snowflake_warehouse.warehouse.name
  }
}

resource "snowflake_grant_account_role" "grant_warehouse_role_to_var_assigned_roles" {
  provider = snowflake.security_admin
  for_each   = {
    for index, role in var.assign_warehouse_role_to_roles:
    role => role
  }

  role_name = module.warehouse_custom_role.custom_role_name
  parent_role_name = "${each.key}"
}
