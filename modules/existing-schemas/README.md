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
      MARTS:
        assign_manage_roles: []
        assign_create_roles: [TL_ROL]
        assign_select_roles: [SPDO_AE_ROL]
        assign_bi_roles: [ BI_ROL ]
```