# Snowflake Warehouse and Role Management infrastructure

This Terraform configuration automates the creation and management of Snowflake warehouses, custom roles, and role grants. It also configures the assignment of custom roles to various user roles within Snowflake, ensuring the correct permissions for warehouse usage.

## Table of contents

1. [Providers used](#providers-used)
2. [Snowflake Warehouse Configuration](#snowflake-warehouse-configuration)
3. [Custom Role Configuration](#custom-role-configuration)
4. [Warehouse Grant Permissions](#warehouse-grant-permissions)
5. [Role Assignment and Management](#role-assignment-and-management)
6. [Variables used](#variables-used)
7. [TL;DR](#tldr)

## Providers used

### 1. Snowflake
- **Source:** `Snowflake-Labs/snowflake`
- **Version:** `0.70.0`
- **Configuration Aliases:**
  - `snowflake.sys_admin`, `snowflake.security_admin`: Used for administrative roles in Snowflake.

### 2. SnowSQL
- **Source:** `aidanmelen/snowsql`
- **Version:** `1.3.3`
- **Configuration Aliases:**
  - `snowsql.sys_admin`, `snowsql.security_admin`: Used for executing SQL statements via SnowSQL.

## Snowflake Warehouse Configuration

### Snowflake Warehouse

- **Resource:** `snowflake_warehouse.warehouse`
- **Description:** Creates a Snowflake warehouse with configurable options.
- **Parameters:**
  - `name`: The name of the warehouse.
  - `warehouse_size`: Size of the warehouse (e.g., 'XSMALL', 'SMALL').
  - `auto_resume`: Whether the warehouse should automatically resume when needed.
  - `auto_suspend`: The time (in seconds) after which the warehouse suspends automatically when idle.
  - `enable_query_acceleration`: Whether query acceleration is enabled for the warehouse.
  - `initially_suspended`: Specifies whether the warehouse should start in a suspended state.
  - `max_cluster_count`: The maximum number of clusters for multi-cluster warehouses.
  - `max_concurrency_level`: The maximum concurrency level for the warehouse.
  - `min_cluster_count`: The minimum number of clusters for multi-cluster warehouses, which is set to `1` if `max_cluster_count > 1`.
  - `query_acceleration_max_scale_factor`: The maximum scale factor for query acceleration.
  - `statement_queued_timeout_in_seconds`: Timeout for queued statements.
  - `statement_timeout_in_seconds`: Timeout for executing statements.
  - `scaling_policy`: Defines the scaling policy for the warehouse (e.g., "STANDARD").

## Custom Role Configuration

### Custom Role for Warehouse

- **Module:** `module.warehouse_custom_role`
- **Description:** Creates a custom role for the Snowflake warehouse to manage its permissions.
- **Parameters:**
  - `custom_role_name`: Name of the custom role, which is derived from the warehouse name.
  - The module depends on the successful creation of the Snowflake warehouse (`snowflake_warehouse.warehouse`).

## Warehouse Grant Permissions

### Warehouse Usage Grant

- **Resource:** `snowflake_warehouse_grant.warehouse_usage`
- **Description:** Grants the custom role created for the warehouse the `USAGE` privilege.
- **Parameters:**
  - `warehouse_name`: The name of the warehouse to which the privilege is applied.
  - `privilege`: The privilege being granted (in this case, "USAGE").
  - `roles`: The custom role created for the warehouse.
  - `with_grant_option`: Whether the role can grant the privilege to others (set to `false`).
  - `enable_multiple_grants`: Allows multiple grants for the same role (set to `true`).

## Role Assignment and Management

### Grant Warehouse Role to Other Roles

- **Resource:** `snowsql_exec.grant_warehouse_role_to_var_assigned_roles`
- **Description:** Grants the custom warehouse role to a list of specified Snowflake roles.
- **Parameters:**
  - Uses a `for_each` loop to iterate over the `var.assing_warehouse_role_to_roles` variable and apply grants for each role.
  - `create` block grants the custom role to each role in the list.
  - `delete` block revokes the custom role from each role in the list.

## Variables used

- **`var.warehouse_name`:** The name of the Snowflake warehouse.
- **`var.warehouse_size`:** The size of the Snowflake warehouse (e.g., 'XSMALL', 'SMALL').
- **`var.auto_suspend`:** The time (in seconds) after which the warehouse will automatically suspend when idle.
- **`var.enable_query_acceleration`:** Enables query acceleration for the warehouse if set to `true`.
- **`var.max_cluster_count`:** Maximum number of clusters for multi-cluster warehouses.
- **`var.max_concurrency_level`:** Maximum concurrency level for the warehouse.
- **`var.query_acceleration_max_scale_factor`:** Max scale factor for query acceleration.
- **`var.statement_queued_timeout_in_seconds`:** Timeout for queued statements.
- **`var.statement_timeout_in_seconds`:** Timeout for executing statements.
- **`var.scaling_policy`:** Defines the scaling policy for the warehouse (e.g., "STANDARD").
- **`var.assing_warehouse_role_to_roles`:** List of roles to which the custom warehouse role should be granted.

## TL;DR

This Terraform configuration sets up a Snowflake warehouse, assigns a custom role to manage it, and grants that role to specified Snowflake roles. It provides a flexible and automated way to manage warehouse permissions in Snowflake, ensuring that the correct roles have access to the necessary warehouse resources.

### Benefits:
- **Automated Warehouse Management:** Easily create and configure Snowflake warehouses with custom settings.
- **Role-Based Access Control:** Assign the warehouse's custom role to various user roles in Snowflake.
- **Flexible Permissions:** The configuration allows for dynamic assignment of roles to the warehouse based on a provided list.
