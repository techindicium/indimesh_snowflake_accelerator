module "storage_integration" {
  source = "../../modules/storage-integration"

  # General
  prefix = var.prefix
  env    = var.env

  # AWS
  arn_format       = var.arn_format
  data_bucket_arns = var.data_bucket_arns
  AWS_ACCESS_KEY_ID = var.AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY = var.AWS_SECRET_ACCESS_KEY

  # Snowflake
  snowflake_integration_user_roles = var.snowflake_integration_user_roles
  bucket_object_ownership_settings = var.bucket_object_ownership_settings

  providers = {
    snowflake.storage_integration_role = snowflake.storage_integration_role
  }
}