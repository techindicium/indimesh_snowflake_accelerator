module "storage_integration" {
  source = "../../modules/storage-integration"

  providers = {
    snowflake.sys_admin    = snowflake.sys_admin
    snowsql.security_admin = snowsql.security_admin
  }

  storage_integration_name        = var.storage_integration_name
  storage_integration_policy_name = var.storage_integration_policy_name
  storage_integration_role_name   = var.storage_integration_role_name

  aws_account_id          = var.aws_account_id
  tf_state_s3_bucket_name = var.tf_state_s3_bucket_name
  region                  = var.region
}
