resource "snowflake_storage_integration" "this" {
  name     = var.storage_integration_name
  provider = snowflake.sys_admin

  storage_provider     = "S3"
  storage_aws_role_arn = "arn:aws:iam::${var.aws_account_id}:role/${var.storage_integration_role_name}"
  enabled              = true
  storage_allowed_locations = [
    "s3://${data.terraform_remote_state.this.outputs.s3_bucket_name}/"
  ]

  comment = "${var.storage_integration_name} - Snowflake Integration with AWS S3"
}

resource "snowsql_exec" "this" {
  depends_on = [snowflake_storage_integration.this]
  provider   = snowsql.security_admin

  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    GRANT USAGE ON INTEGRATION "${snowflake_storage_integration.this.name}" TO ROLE LOADER_ROL;
    EOT
  }

  read {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    DESC INTEGRATION "${snowflake_storage_integration.this.name}";
    EOT
  }

  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    REVOKE USAGE ON INTEGRATION "${snowflake_storage_integration.this.name}" FROM ROLE LOADER_ROL;
    EOT
  }
}
