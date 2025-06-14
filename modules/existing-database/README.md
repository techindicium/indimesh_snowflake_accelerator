# Database infrastructure

This module aims creation and configuration of custom roles in a Snowflake environment to grant permission to an existing database in the referenced Snowflake. It organizes roles and their permissions in a modular way and assigns roles hierarchically based on defined rules and relationships.

## Table of contents


1. [Created Custom Roles](#created-custom-roles)
2. [Role Relationships](#role-relationships)
3. [Configured Permissions](#configured-permissions)
4. [Role Assignments](#role-assignments)
5. [Technical Settings](#technical-settings)

## Created Custom Roles

### 1. `manage_custom_role`
- Name: `DB_<db_name>_MNG_ROL`
- Description: Primary management role.
- Permissions:
- Full control over database schemas and tables.
- Inherits permissions from `SYSADMIN`.

### 2. `create_custom_role`
- Name: `DB_<db_name>_CRT_ROL`
- Description: Role to create schemas and objects in the database.
- Permissions:
- Create schemas.
- Does not inherit permissions from `SYSADMIN`.

### 3. `select_custom_role`
- Name: `DB_<db_name>_SEL_ROL`
- Description: Role with read permissions (SELECT).
- Permissions:
- SELECT on tables, views, materialized views and external tables.
- USAGE on schemas and databases.

### 4. `bi_custom_role`
- Name: `DB_<db_name>_BI_ROL`
- Description: Optional role for Business Intelligence (BI) tools.
- Permissions:
- SELECT on objects in the `marts_schema` schema.
- Condition: Created only if the `create_bi_role` variable is `true`.

## Relationship between roles

Custom roles are organized hierarchically:

- `create_custom_role` is granted to `manage_custom_role`.
- `select_custom_role` is granted to `create_custom_role`.
- `bi_custom_role` (when created) is granted to `select_custom_role`.

## Configured permissions

### Management permissions
- Granted to `manage_custom_role`:
- Full control (`ALL PRIVILEGES`) on tables, schemas, and databases.

### Creation permissions
- Granted to `create_custom_role`:
- Create schemas.
- USAGE on the database.

### Read permissions
- Granted to `select_custom_role`:
- SELECT on tables, views, materialized views, and external tables.
- USAGE on schemas and databases.

### BI permissions
- Granted to `bi_custom_role` (optional):
- SELECT on objects in the `marts_schema` schema.

## Role assignments

Created roles are assigned to existing roles, defined by variables:

- `var.assign_manage_roles`: Assigns the `manage_custom_role` role.
- `var.assign_create_roles`: Assigns the `create_custom_role` role.
- `var.assign_select_roles`: Assigns the `select_custom_role` role.
- `var.assign_bi_roles`: Assigns the `bi_custom_role` role.

## Technical Settings

### 1. Providers
The code uses one provider:
- `snowflake`: To manage roles and permissions in Snowflake.

### 2. Dependencies
- All modules and features depend on an existing database.

### 3. Configuration

```yaml
existing_databases:
  DB_EXISTING:
    database_name: DB_EXISTING
    database_comment: "DB_EXISTING stuff"
    assign_manage_roles: [TL_ROL, DE_ROL, LOADER_ROL]
    assign_create_roles: [ ]
    assign_select_roles: [LOADER_ROL]
    assign_bi_roles: [BI_ROL]
    create_bi_role: false
    schemas:
```

### 4. Conditions
- The `bi_custom_role` role and its permissions are set only if `var.create_bi_role` is `true`.


## TL;DR

This code:

1. Creates four custom roles with different levels of permissions.
2. Manages permission hierarchies between roles.
3. Assigns created roles to existing roles based on variables. 
4. Uses Terraform modules to facilitate code reuse and maintenance.
