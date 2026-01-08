module "spcs_compute_pools" {
  source   = "../../modules/spcs-compute-pool"
  for_each = local.config.spcs_compute_pools

  compute_pool_name   = each.value.compute_pool_name
  instance_family     = each.value.instance_family
  min_nodes           = each.value.min_nodes
  max_nodes           = each.value.max_nodes
  auto_resume         = try(each.value.auto_resume, true)
  initially_suspended = try(each.value.initially_suspended, true)
  auto_suspend_secs   = try(each.value.auto_suspend_secs, 300)

  usage_roles          = try(each.value.usage_roles, [])
  all_privileges_roles = try(each.value.all_privileges_roles, [])

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
  }

}