output "s3_external_url" {
  value = "s3://${data.terraform_remote_state.this.outputs.s3_bucket_name}"
}

output "snowflake_s3_datalake_storage_integration_name" {
  value = snowflake_storage_integration.this.name
}

output "snowflake_s3_datalake_storage_integration_aws_iam_user_arn" {
  value = snowflake_storage_integration.this.storage_aws_iam_user_arn
}

output "snowflake_s3_datalake_storage_integration_aws_external_id" {
  value = snowflake_storage_integration.this.storage_aws_external_id
}
