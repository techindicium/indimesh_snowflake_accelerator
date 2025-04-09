variable "storage_integration_name" {
  description = "Storage Integration name"
}

variable "storage_integration_role_name" {
  description = "Storage Integration role name for Snowflake storage integration"
}

variable "storage_integration_policy_name" {
  description = "Storage Integration policy name for Snowflake storage integration"
}

variable "tf_state_s3_bucket_name" {
  description = "Name of the S3 bucket that stores the project's Terraform states"
}

variable "region" {
  description = "AWS region where the S3 bucket stores the Terraform states"
}

variable "aws_account_id" {
  description = "AWS account ID"
}
