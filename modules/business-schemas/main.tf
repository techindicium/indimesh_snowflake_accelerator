terraform {
  required_providers {
    snowflake = {
      source                = "Snowflake-Labs/snowflake"
      version               = "0.98.0"
      configuration_aliases = [snowflake.sys_admin, snowflake.security_admin]
    }
    snowsql = {
      source                = "aidanmelen/snowsql"
      version               = "1.3.3"
      configuration_aliases = [snowsql.sys_admin, snowsql.security_admin]
    }
  }
}

resource "snowflake_schema" "schema_name" {
    provider                    = snowflake.sys_admin
    name                        = var.schema_name
    database                    = var.database_name
}

resource "snowflake_file_format" "file_format" {
    depends_on                  = [ snowflake_schema.schema_name ]
    provider                    = snowflake.sys_admin
    name                        = var.file_format_name
    database                    = var.database_name
    schema                      = var.schema_name
    format_type                 = var.file_format
    null_if                     = var.format_null
}

resource "snowflake_stage" "stage" {
  provider = snowflake.sys_admin
  depends_on = [ snowflake_file_format.file_format ]

  name = var.stage_name
  database = var.database_name
  schema = var.schema_name
  storage_integration = var.storage_integration
  url = var.url_s3
}

resource "snowflake_grant_ownership" "grant_stage_ownership_to_sysadmin" {
  provider = snowflake.sys_admin
  account_role_name = "SYSADMIN"
  outbound_privileges = "COPY"

  on {
    object_type = "STAGE"
    object_name = "${var.database_name}.${var.schema_name}.${var.stage_name}"
  }
}
