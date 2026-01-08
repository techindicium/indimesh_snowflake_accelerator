resource "snowflake_compute_pool" "this" {
  provider = snowflake.sys_admin

  name              = var.compute_pool_name
  min_nodes         = var.min_nodes
  max_nodes         = var.max_nodes
  instance_family   = var.instance_family
  auto_suspend_secs = var.auto_suspend_secs

  auto_resume         = tostring(var.auto_resume)
  initially_suspended = tostring(var.initially_suspended)
}