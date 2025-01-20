# IAM and Storage Integration for Snowflake infrastructure

This Terraform configuration manages the IAM roles, policies, S3 bucket notifications, and Snowflake storage integration required for setting up an automated data pipeline. It integrates AWS S3 with Snowflake, utilizing SNS notifications for object creation events.

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
- **Version:** `>= 4.38.0`
- **Resources Managed:**
  - IAM roles, policies, and bucket configurations.
  - SNS topics and notifications.

### 2. Snowflake
- **Source:** `Snowflake-Labs/snowflake`
- **Version:** `>= 0.70.0`
- **Configuration Aliases:**
  - `snowflake.storage_integration_role`: Used for managing Snowflake storage integration roles.

## IAM Role and Policies

### Snowflake Storage Role

- **Resource:** `aws_iam_role.s3_reader`
- **Description:** Creates an IAM role that allows Snowflake to access the S3 bucket.
- **Assume Role Policy:**
  - Allows the Snowflake storage integration IAM user to assume the role.
  - External ID validation is used for additional security.

### IAM Policy for S3 Permissions

- **Resource:** `aws_iam_role_policy.s3_reader`
- **Description:** Creates an IAM policy granting permissions to interact with the specified S3 bucket.
- **Permissions:**
  - `s3:PutObject`, `s3:GetObject`, `s3:GetObjectVersion`: Allows reading and writing to objects in the bucket.
  - `s3:ListBucket`: Allows listing the objects in the bucket, with a condition on prefix matching.

## S3 Bucket Configuration

### S3 Bucket

- **Resource:** `aws_s3_bucket.geff_bucket`
- **Description:** Defines an S3 bucket to store data for Snowflake integration.
- **Bucket Name:** Defined by the variable `local.s3_bucket_name`.

### S3 Ownership Controls

- **Resource:** `aws_s3_bucket_ownership_controls.geff_bucket_ownership_controls`
- **Description:** Configures ownership controls for the S3 bucket to specify object ownership rules.

### S3 Bucket ACL

- **Resource:** `aws_s3_bucket_acl.geff_bucket_acl`
- **Description:** Sets the ACL for the bucket based on ownership settings.

### S3 Meta Folder

- **Resource:** `aws_s3_object.geff_meta_folder`
- **Description:** Creates a folder named `meta/` within the S3 bucket to store metadata.

## Storage Integration

### Snowflake Storage Integration

- **Resource:** `snowflake_storage_integration.this`
- **Description:** Creates a Snowflake storage integration to connect Snowflake to the S3 bucket.
- **Parameters:**
  - `storage_allowed_locations`: Specifies the allowed locations for external storage.
  - `storage_provider`: Dynamically set based on the region (e.g., "S3GOV" for GovCloud).
  - `storage_aws_role_arn`: Specifies the IAM role ARN used for access to the S3 bucket.

### Snowflake Integration Grant

- **Resource:** `snowflake_integration_grant.this`
- **Description:** Grants the `OWNERSHIP` privilege for the storage integration to the `SYSADMIN` role in Snowflake.

## Notifications

### SNS Topic

- **Resource:** `aws_sns_topic.geff_bucket_sns`
- **Description:** Creates an SNS topic to notify about object creation events in the S3 bucket.

### SNS Topic Policy

- **Resource:** `aws_sns_topic_policy.geff_s3_sns_topic_policy`
- **Description:** Defines the policy for the SNS topic that allows Snowflake to subscribe to the topic and receive notifications.

### S3 Bucket Notification

- **Resource:** `aws_s3_bucket_notification.geff_s3_bucket_notification`
- **Description:** Configures the S3 bucket to trigger the SNS topic when an object is created in the bucket.

### S3 Pipeline Bucket Notification

- **Resource:** `aws_s3_bucket_notification.geff_s3_pipline_bucket_notification`
- **Description:** Configures S3 bucket notifications for additional pipeline buckets based on the `pipeline_bucket_ids`.

## Variables used

- **`local.s3_reader_role_name`:** The name of the IAM role that Snowflake will assume for accessing the S3 bucket.
- **`local.s3_bucket_name`:** The name of the S3 bucket where data will be stored.
- **`local.s3_sns_topic_name`:** The base name of the SNS topic for notifications.
- **`var.bucket_object_ownership_settings`:** The object ownership settings for the S3 bucket.
- **`var.data_bucket_arns`:** A list of ARNs for additional S3 buckets used in the data pipeline.
- **`local.pipeline_bucket_ids`:** A list of S3 bucket IDs to be used for additional pipeline notifications.
- **`var.prefix`:** Prefix used for Snowflake storage integration.
- **`local.account_id`:** The AWS account ID used in role ARNs.

## TL;DR

This Terraform configuration sets up the integration between Snowflake and AWS S3, enabling Snowflake to access data stored in S3. It creates necessary IAM roles and policies, configures the S3 bucket and SNS notifications, and ensures Snowflake can interact with the data stored in S3 using a storage integration.

### Benefits:
- **Seamless Snowflake-S3 Integration:** Automatically integrates Snowflake with S3 for data storage and management.
- **Granular IAM Permissions:** Provides specific permissions for Snowflake to access the S3 bucket based on roles and policies.
- **Real-Time Notifications:** Configures SNS notifications to alert Snowflake about new objects created in the S3 bucket.
- **Scalable Architecture:** Easily extendable to include more S3 buckets or other integrations as the pipeline grows.
