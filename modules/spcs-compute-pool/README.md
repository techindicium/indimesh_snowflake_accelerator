# Snowflake Compute Pool Module

This Terraform module automates the creation and management of **Snowflake Compute Pools**, including configuration of instance families, auto-suspension policies, and role-based access control (RBAC). It ensures that the compute pool is correctly provisioned for Snowflake's Snowpark Container Services (SPCS).

## Table of contents

1. [Providers used](#providers-used)
2. [Snowflake Compute Pool Configuration](#snowflake-compute-pool-configuration)
3. [Access Control Configuration](#access-control-configuration)
4. [Variables used](#variables-used)
5. [TL;DR](#tldr)

## Providers used

### 1. Snowflake
- **Source:** `snowflakedb/snowflake`
- **Version:** `>= 2.6.0`
- **Configuration Aliases:**
  - `snowflake.sys_admin`: Used for creating the compute pool.
  - `snowflake.security_admin`: Used for managing grants and permissions.

**IMPORTANT:** You must enable `preview_features_enabled` in your provider configuration.

```hcl
provider "snowflake" {
  alias = "security_admin"
  role  = "SECURITYADMIN"
  
  # This feature is in preview and must be explicitly enabled
  preview_features_enabled = [
    "snowflake_compute_pool_resource",
  ]
}
```

## Snowflake Compute Pool Configuration

### Compute Pool Resource

- **Resource:** `snowflake_compute_pool.this`
- **Description:** Creates a Snowflake Compute Pool, which is a collection of nodes that execute Snowpark Container Services.
- **Parameters:**
  - `name`: The name of the compute pool.
  - `min_nodes`: Minimum number of nodes in the pool.
  - `max_nodes`: Maximum number of nodes in the pool.
  - `instance_family`: The instance family for the nodes (e.g., `CPU_X64_XS`, `GPU_NV_S`).
  - `auto_resume`: Whether the pool should automatically resume when a service or job is started.
  - `initially_suspended`: Specifies whether the pool starts in a suspended state.
  - `auto_suspend_secs`: The time (in seconds) after which the pool suspends automatically when idle.

## Access Control Configuration

### Compute Pool Grants

- **Resource:** `snowflake_grant_privileges_to_account_role`
- **Description:** Manages privileges for accessing and operating the compute pool.
- **Privileges:**
  - **USAGE:** Grants roles the ability to use the compute pool to run services.
  - **ALL PRIVILEGES:** Grants administrative control over the compute pool.

- **Parameters:**
  - `usage_roles`: A list of Snowflake account roles that receive `USAGE` privileges.
  - `all_privileges_roles`: A list of Snowflake account roles that receive `ALL PRIVILEGES`.

## Variables used

- **`var.compute_pool_name`:** The name of the compute pool.
- **`var.min_nodes`:** Minimum number of nodes.
- **`var.max_nodes`:** Maximum number of nodes.
- **`var.instance_family`:** Instance family identifier (e.g., `CPU_X64_XS`).
- **`var.auto_resume`:** Enable auto-resume (default: `true`).
- **`var.initially_suspended`:** Start suspended (default: `true`).
- **`var.auto_suspend_secs`:** Auto-suspend time in seconds (default: `300`).
- **`var.usage_roles`:** List of roles to grant `USAGE`.
- **`var.all_privileges_roles`:** List of roles to grant `ALL PRIVILEGES`.

## TL;DR

This module simplifies the deployment of Snowflake Compute Pools for Snowpark Container Services. It abstracts the complexity of resource creation and permission management, allowing you to define scalable compute infrastructure with simple Terraform configuration.

### Benefits:
- **Simplified Provisioning:** Create complex compute pools with minimal code.
- **Integrated Security:** Automatically handle role grants for usage and administration.
- **Cost Management:** Built-in defaults for auto-suspension to optimize credits.
