resource "snowflake_warehouse" "warehouse" {
  provider                            = snowflake.account_admin
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