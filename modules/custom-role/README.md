# Custom role infrastructure

This Terraform code automates the creation of a custom role in Snowflake and manages its inheritance to existing roles (`SYSADMIN` and `SECURITYADMIN`) based on a conditional variable.

## Table of contents

1. [Providers used](#providers-used)
2. [Configuration structure](#configuration-structure)
3. [Local variables](#local-variables)
4. [Resources created](#resources-created)
5. [Dynamic conditions](#dynamic-conditions)
6. [Dependencies and flow](#dependencies-and-flow)
7. [Variables used](#variables-used)
8. [TL;DR](#tldr)

## Providers used

### 1. Snowflake
- **Source:** `Snowflake-Labs/snowflake`
- **Version:** `0.70.0`
- **Aliases:**
  - `sys_admin`: Not used in this code but available for future administrative tasks.
  - `security_admin`: Used to create and manage roles in Snowflake.

### 2. Snowsql
- **Source:** `aidanmelen/snowsql`
- **Version:** `1.3.3`
- **Aliases:**
  - `sys_admin`: Not used in this code but set for potential use in command execution.
  - `security_admin`: Used to execute SQL commands for role inheritance management.

## Configuration structure

This code defines the creation of a custom role in Snowflake and conditional inheritance to higher-level roles.

## Local variables

- **Not explicitly defined:** This code does not use `locals`, but it relies on input variables to configure behavior dynamically.

## Resources created

### 1. Custom Role
- **Resource:** `snowflake_role.custom_role`
- **Description:** Creates a new role in Snowflake.
- **Parameters:**
  - `name`: The name of the role, provided by `var.custom_role_name`.

### 2. Role Inheritance Management
- **Resource:** `snowsql_exec.inherit_role`
- **Description:** Conditionally grants and revokes the custom role's inheritance to/from `SYSADMIN` and `SECURITYADMIN`.
- **Parameters:**
  - **Create Block:**
    - Grants the custom role to `SYSADMIN` and `SECURITYADMIN`.
  - **Delete Block:**
    - Revokes the custom role from `SYSADMIN` and `SECURITYADMIN`.

## Dynamic conditions

### Conditional Execution
- **Resource:** `snowsql_exec.inherit_role`
- **Condition:** The `count` parameter determines whether the inheritance logic is applied.
  - If `var.inherit_sysadmin` is `true`, the resource is created with `count = 1`.
  - If `var.inherit_sysadmin` is `false`, the resource is skipped with `count = 0`.

## Dependencies and flow

1. **Custom Role Creation:**
   - The `snowflake_role.custom_role` resource defines and creates the role.

2. **Inheritance Management:**
   - The `snowsql_exec.inherit_role` resource depends on the custom role being created.
   - The SQL statements dynamically grant or revoke the role to/from `SYSADMIN` and `SECURITYADMIN`.

## Variables used

### 1. `var.custom_role_name`
- **Description:** The name of the custom role to be created.
- **Type:** String

### 2. `var.inherit_sysadmin`
- **Description:** Determines if the custom role should inherit `SYSADMIN` and `SECURITYADMIN`.
- **Type:** Boolean
- **Default Value:** Not specified in the provided code.

## TL;DR

This Terraform code creates a custom role in Snowflake and manages its inheritance to `SYSADMIN` and `SECURITYADMIN` roles based on a conditional flag. It leverages both `snowflake` and `snowsql` providers for role creation and command execution.

### Benefits:
- **Automated Role Creation:** Ensures consistent role definitions.
- **Conditional Inheritance:** Provides flexibility in determining role relationships.
- **Dynamic Command Execution:** Uses SQL statements for efficient role management.
