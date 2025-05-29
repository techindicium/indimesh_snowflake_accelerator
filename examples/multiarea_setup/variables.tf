variable "aws_region" {
  description = "The AWS region in which the AWS infrastructure is created."
  type        = string
  default     = "us-east-2"
}

variable "snowflake_account" {
  type      = string
  sensitive = true
  default   = "WHYQFQG-IQ65686"
}

#The prefix is a naming string on the storage-integration module on storage_integration.tf
variable "prefix" {
  type        = string
  description = "this will be the prefix used to name the Resources on Storage-integration's module."
  default     = "pocdev"
}

variable "snowflake_integration_user_roles" {
  type        = list(string)
  default     = ["ACCOUNTADMIN"] #accountadmin
  description = "List of roles to which GEFF infra will GRANT USAGE ON INTEGRATION perms."
}

variable "data_bucket_arns" {
  type        = list(string)
  default     = ["arn:aws:s3:::mybucket"]
  description = "List of Bucket ARNs for the s3_reader role to read from."
}

variable "arn_format" {
  type        = string
  description = "ARN format could be aws or aws-us-gov. Defaults to non-gov."
  default     = "aws"
}

variable "bucket_object_ownership_settings" {
  type        = string
  description = "The settings that will impact ACLs and ownership of objects within the bucket."
  default     = "BucketOwnerEnforced"
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

variable "snowflake_storage_integration_owner_role" {
  type    = string
  default = "ACCOUNTADMIN"
}

variable "env" {
  type    = string
  default = "prod"
}

variable "AWS_REGION" {
  description = "AWS Region to be used on the Storage-Integration module."
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key to be used on the Storage-Integration module."
  type        = string
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Acess Key ID to be used on the Storage-Integration module."
  type        = string
}

variable "storage_integration_name" {
  type        = string
  description = "Storage integration name"
  default     = "DEMO_PROJECT_STORAGE_INTEGRATION"
}

variable "storage_integration_policy_name" {
  type        = string
  description = "Storage integration policy name"
  default     = "STORAGE_INTEGRATION_POLICY"
}

variable "storage_integration_role_name" {
  type        = string
  description = "Storage integration role name"
  default     = "POCDEV_STORAGE_INTEGRATION"
}

variable "aws_account_id" {
  type        = string
  description = "AWS account id"
  default     = "835825599161"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "tf_state_s3_bucket_name" {
  type        = string
  description = "Terrraform backend S3 bucket name"
  default     = "indicium-mesh-tfstates"
}

variable "aws_sns_topic_arn" {
  type        = string
  description = "ARN of the AWS SNS topic which will receive alerts"
}