module "snowflake_warehouses" {
  for_each = local.config.warehouses
  source   = "../../modules/warehouse"

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
    snowsql.sys_admin        = snowsql.sys_admin
    snowsql.security_admin   = snowsql.security_admin
  }
  warehouse_name                      = each.value.warehouse_name
  warehouse_size                      = each.value.warehouse_size
  auto_suspend                        = each.value.auto_suspend
  enable_query_acceleration           = each.value.enable_query_acceleration
  max_cluster_count                   = each.value.max_cluster_count
  max_concurrency_level               = each.value.max_concurrency_level
  query_acceleration_max_scale_factor = each.value.query_acceleration_max_scale_factor
  statement_queued_timeout_in_seconds = each.value.statement_queued_timeout_in_seconds
  statement_timeout_in_seconds        = each.value.statement_timeout_in_seconds
  scaling_policy                      = each.value.scaling_policy
  create_optional_resource            = false
  auto_resume                         = true 
  
  # Iterate all roles created with custom_role module and return only those included in the
  # assign_warehouse_role_to_roles config
  assign_warehouse_role_to_roles = [
    for index, custom_role in module.custom_roles : custom_role.custom_role_name
    if contains(each.value.assign_warehouse_role_to_roles, custom_role.custom_role_name)
  ]
}

