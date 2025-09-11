terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
      version = "2.6.0"
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
    with_managed_access         = true
}

resource "snowflake_file_format" "file_format" {
    depends_on                  = [ snowflake_schema.schema_name ]
    provider                    = snowflake.sys_admin
    name                        = var.file_format_name
    database                    = var.database_name
    schema                      = var.schema_name
    format_type                 = var.file_format
    skip_header                 = var.file_format == "CSV" ? 1 : 0
    null_if                     = var.format_null
}

resource "snowsql_exec" "create_stage" {
    depends_on                  = [ snowflake_file_format.file_format ]
    provider                    = snowsql.sys_admin

    create {
        statements = <<-EOT
            USE ROLE sysadmin;
            CREATE OR REPLACE STAGE ${var.database_name}.${var.schema_name}.${var.stage_name} URL= ${var.url_s3} FILE_FORMAT=${var.database_name}.${var.schema_name}.${var.file_format_name} STORAGE_INTEGRATION=${var.storage_integration};
            GRANT OWNERSHIP ON STAGE ${var.database_name}.${var.schema_name}.${var.stage_name} to role SYSADMIN copy current grants;
        EOT
    }
    delete {
        statements = <<-EOT
            USE ROLE SYSADMIN;
        EOT
    }
}
