# Snowflake Image Repository Module

This Terraform module automates the creation and management of **Snowflake Image Repositories** within a specified database and schema. It also handles role-based access control (RBAC), ensuring that specified roles have the correct `READ` or `WRITE` privileges to push and pull container images.

## Table of contents

1. [Providers used](#providers-used)
2. [Snowflake Image Repository Configuration](#snowflake-image-repository-configuration)
3. [Access Control Configuration](#access-control-configuration)
4. [Variables used](#variables-used)
5. [TL;DR](#tldr)

## Providers used

### 1. Snowflake
- **Source:** `snowflakedb/snowflake`
- **Version:** `>= 2.6.0`
- **Configuration Aliases:**
  - `snowflake.sys_admin`: Used for creating the image repository.
  - `snowflake.security_admin`: Used for managing grants and permissions.

**IMPORTANT:** You must enable `preview_features_enabled` in your provider configuration.

```hcl
provider "snowflake" {
  alias = "security_admin"
  role  = "SECURITYADMIN"
  
  # This feature is in preview and must be explicitly enabled
  preview_features_enabled = [
    "snowflake_image_repository_resource",
  ]
}
```

## Snowflake Image Repository Configuration

### Image Repository Resource

- **Resource:** `snowflake_image_repository.this`
- **Description:** Creates a Snowflake Image Repository, which provides a secure repository for storing OCIv2-compliant container images.
- **Parameters:**
  - `database_name`: The Snowflake database in which to create the repository.
  - `schema_name`: The Snowflake schema in which to create the repository.
  - `image_repository_name`: The name of the image repository.

## Access Control Configuration

### Image Repository Grants

- **Resource:** `snowflake_grant_privileges_to_account_role`
- **Description:** Manages privileges for accessing the image repository.
- **Privileges:**
  - **READ:** Allows a role to list and pull images from the repository.
  - **WRITE:** Allows a role to push images to the repository (effectively implies read access).

- **Parameters:**
  - `read_roles`: A list of Snowflake account roles that receive `READ` privileges.
  - `write_roles`: A list of Snowflake account roles that receive both `READ` and `WRITE` privileges.

## Variables used

- **`var.database_name`:** The name of the Snowflake database.
- **`var.schema_name`:** The name of the Snowflake schema.
- **`var.image_repository_name`:** The name of the image repository.
- **`var.read_roles`:** List of roles to grant `READ` access.
- **`var.write_roles`:** List of roles to grant `WRITE` (and `READ`) access.

## TL;DR

This module simplifies the setup of Snowflake Image Repositories for Snowpark Container Services, abstracting the creation of the repository artifact and the assignment of complex privilege sets.

### Benefits:
- **Simplified Repository Setup:** Quickly provision OCI repositories in Snowflake.
- **Managed Permissions:** Automatically grants the correct set of privileges for consumers (read-only) and producers (read-write).
- **Secure by Design:** Ensures that image assets are stored within your Snowflake governance boundary.
