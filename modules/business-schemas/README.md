# Schema infrastructure

This Terraform code configures a **schema**, a **file format**, and a **stage** in Snowflake, using two providers: `snowflake` and `snowsql`. The implementation considers dependencies between resources and ensures an integrated and reusable configuration.

## Table of contents

1. [Providers used](#providers-used)
2. [Resources created](#resources-created)
3. [Resource dependencies](#resource-dependencies)
4. [Variables used](#variables-used)
5. [Technical configurations](#technical-configurations)
6. [TL;DR](#tldr)

## Providers used

### 1. Snowflake
- **Source:** `Snowflake-Labs/snowflake`
- **Version:** `0.70.0`
- **Aliases:**
- `sys_admin`: For managing schemas and file formats.
- `security_admin`: Not used in this code, but defined for future configurations.

### 2. Snowsql
- **Source:** `aidanmelen/snowsql`
- **Version:** `1.3.3`
- **Aliases:**
- `sys_admin`: To execute SQL commands in Snowflake.
- `security_admin`: Not used in this code, but defined for future configurations.

## Resources created

### 1. Schema
- **Resource:** `snowflake_schema.schema_name`
- **Description:** Creates a schema in the specified database.
- **Parameters:**
- `name`: Schema name (`var.schema_name` variable).
- `database`: Database name (`var.database_name` variable).
- **Provider:** `snowflake.sys_admin`.

### 2. File Format
- **Resource:** `snowflake_file_format.file_format`
- **Description:** Defines a file format associated with the created schema.
- **Parameters:**
- `name`: Name of the file format (`var.file_format_name` variable).
- `database`: Name of the database (`var.database_name` variable).
- `schema`: Name of the schema (`var.schema_name` variable).
- `format_type`: Type of file format (`var.file_format` variable).
- `null_if`: Configuration for null values ​​(`var.format_null` variable).
- **Dependency:** Depends on the schema (`snowflake_schema.schema_name`).
- **Provider:** `snowflake.sys_admin`.

### 3. Stage
- **Resource:** `snowsql_exec.create_stage`
- **Description:** Creates a stage in Snowflake using an SQL command executed via `snowsql`.
- **Parameters:**
 - SQL command to create the stage:
 ```sql
 USE ROLE sysadmin;
 CREATE OR REPLACE STAGE <database_name>.<schema_name>.<stage_name>
 URL= <url_s3>
 FILE_FORMAT=<database_name>.<schema_name>.<file_format_name>
 STORAGE_INTEGRATION=<storage_integration>;
 GRANT OWNERSHIP ON STAGE <database_name>.<schema_name>.<stage_name>
 TO ROLE SYSADMIN COPY CURRENT GRANTS;
 ```
- SQL command for deletion (placeholder):
```sql
USE ROLE SYSADMIN;
```
- **Dependency:** Depends on the file format (`snowflake_file_format.file_format`).
- **Provider:** `snowsql.sys_admin`.

## Dependencies between resources

1. **File Format (`file_format`)** depends on the **schema (`schema_name`)**.
2. **Stage (`create_stage`)** depends on the **file format (`file_format`)**.

## Variables used

### General parameters
- `var.schema_name`: Schema name.
- `var.database_name`: Database name.

### File format
- `var.file_format_name`: File format name.
- `var.file_format`: File format type (e.g. `CSV`, `JSON`).
- `var.format_null`: Values ​​treated as null in the file format.

### Stage
- `var.stage_name`: Name of the stage.
- `var.url_s3`: URL of the S3 bucket for the stage.
- `var.storage_integration`: Name of the storage integration for the stage.

## Technical Configurations

- **Provider Aliases:** Using aliases (`sys_admin` and `security_admin`) allows you to manage different roles in Snowflake in a modular way.
- **Dynamic SQL Commands:** The `snowsql_exec` resource uses variables to dynamically create and configure the stage.
- **Order Guarantee:** Explicit dependencies (`depends_on`) ensure that resources are provisioned in the correct order.

## TL;DR

This Terraform code:
1. Creates a schema in Snowflake.
2. Defines a file format associated with the schema.
3. Configures a stage that uses the file format and integrates with an S3 bucket.
4. Uses dependencies to ensure an orderly and functional configuration.