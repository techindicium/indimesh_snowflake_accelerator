# IAM and Storage Integration for Snowflake infrastructure

This Terraform configuration manages the IAM roles, policies, and Snowflake storage integration required to set up an automated data pipeline.

## Table of contents

1. [Providers used](#providers-used)
2. [IAM Role and Policies](#iam-role-and-policies)
3. [S3 Bucket Configuration](#s3-bucket-configuration)
4. [Storage Integration](#storage-integration)
5. [Notifications](#notifications)
6. [Variables used](#variables-used)
7. [TL;DR](#tldr)

## Providers used

### 1. AWS
- **Source:** `hashicorp/aws`
- **Version:** `>= 5.0`
- **Resources Managed:**
  - IAM roles, policies, and bucket configurations.
  - SNS topics and notifications.

### 2. Snowflake
- **Source:** `Snowflake-Labs/snowflake`
- **Version:** `>= 0.97.0`
- **Configuration Aliases:**
  - `snowflake.sys_admin`: Used to create Snowflake storage integration.

### 3. Snowsql
- **Source:** `aidanmelen/snowsql`
- **Version:** `>= 1.3.3`
- **Configuration Aliases:**
  - `snowsql.security_admin`: Used for managing Snowflake storage integration roles.

## IAM Role and Policies

### Snowflake Storage Role

- **Resource:** `aws_iam_role.this`
- **Description:** Creates an IAM role that allows Snowflake to access the S3 bucket.
- **Assume Role Policy:**
  - Allows the Snowflake storage integration IAM user to assume the role.
  - External ID validation is used for additional security.

### IAM Policy for S3 Permissions

- **Resource:** `aws_iam_role_policy_attachment.this`
- **Description:** Creates an IAM policy granting permissions to interact with the specified S3 bucket.
- **Permissions:**
  - `s3:PutObject`, `s3:GetObject`, `s3:GetObjectVersion`: Allows reading and writing to objects in the bucket.
  - `s3:ListBucket`: Allows listing the objects in the bucket, with a condition on prefix matching.
  - `s3:DeleteObject`, `s3:DeleteObjectVersion`, `s3:GetBucketLocation`: Allows deleting existing objects within the bucket.

## S3 Bucket Configuration

### S3 Remote State

- **Resource:** `data.terraform_remote_state.this`
- **Description:** Fetches the state of the ingestion step in the passed Bucket using the `key` variable in the resource, and returns to the `snowflake_storage_integration.this` resource the name of the Bucket that stores the ingested data in Parquet format.
- **Bucket name:** Defined by the variables `var.tf_state_s3_bucket_name` and `var.region`.

## Storage Integration

### Snowflake Storage Integration

- **Resource:** `snowflake_storage_integration.this`
- **Description:** Creates a Snowflake storage integration to connect Snowflake to the S3 bucket that stores the data of interest.
- **Parameters:**
- `storage_allowed_locations`: Specifies the allowed locations for external storage.
- `storage_provider`: Dynamically set based on the region.
- `storage_aws_role_arn`: Specifies the ARN of the IAM role used to access the S3 bucket.

### Snowflake Integration Grant

- **Resource:** `snowflake_integration_grant.this`
- **Description:** Grants the `USAGE` privilege for the storage integration to the `SECURITYADMIN` role in Snowflake.

## Variables used

- **`storage_integration_name`:** Defines the name of the Storage Integration.
- **`storage_integration_role_name`:** Defines the name of the Storage Integration role.
- **`storage_integration_policy_name`:** Defines the name of the Storage Integration policy.
- **`tf_state_s3_bucket_name`:** Defines the name of the S3 Bucket that stores the project states.
- **`region`:** Region where the S3 Bucket that stores the project states is located.
- **`aws_accont_id`:** ID of the AWS account where the S3 Bucket that stores the project states is located.

## TL;DR

This Terraform configuration sets up the integration between Snowflake and AWS S3, enabling Snowflake to access data stored in S3. It creates necessary IAM roles and policies and ensures Snowflake can interact with the data stored in S3 using a storage integration.

### Benefits:
- **Seamless Snowflake and S3 Integration:** Automatically integrates Snowflake with S3 for data storage and management.
- **Granular IAM Permissions:** Provides specific permissions for Snowflake to access your S3 bucket based on roles and policies.
