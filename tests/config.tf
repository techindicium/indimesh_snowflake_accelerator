locals {
  wh_terraform                        = "TERRAFORM_WH"
  warehouse_name                      = "WH_TEST"
  warehouse_size                      = "X-Small"
  auto_suspend                        = 300
  enable_query_acceleration           = false
  max_concurrency_level               = 2
  max_cluster_count                   = 1
  query_acceleration_max_scale_factor = 0
  statement_queued_timeout_in_seconds = 300
  statement_timeout_in_seconds        = 300
  scaling_policy                      = null
  database_name                       = "TEST_DATABASE"
  database_role_name                  = "TEST_DATABASE_ROLE"
  warehouse_role_name                 = "TEST_WH_ROLE"
  team_role_name                      = "TEST_TEAM_ROLE"
  schema_name                         = ["schema_test"]
}