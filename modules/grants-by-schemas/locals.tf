locals {
  role_type_suffixes = ["MNG", "CRT", "SEL", "BI"]

  manage_grants = flatten([
    for schema_name, conf in var.schemas : [
      for role in conf.assign_manage_roles : {
        schema = schema_name
        role   = role
      }
    ]
  ])

  manage_role_assignments_map = {
    for item in local.manage_grants :
      "${item.schema}.MNG_TO_${item.role}" => {
        db_role_to_grant_fqn = snowflake_database_role.database_roles["${item.schema}.MNG"].fully_qualified_name
        parent_account_role  = item.role
      }
  }

  create_grants = flatten([
    for schema_name, conf in var.schemas : [
      for role in conf.assign_create_roles : {
        schema = schema_name
        role   = role
      }
    ]
  ])

  create_role_assignments_map = {
    for item in local.create_grants :
      "${item.schema}.CRT_TO_${item.role}" => {
        db_role_to_grant_fqn = snowflake_database_role.database_roles["${item.schema}.CRT"].fully_qualified_name
        parent_account_role  = item.role
      }
  }

  select_grants = flatten([
    for schema_name, conf in var.schemas : [
      for role in conf.assign_select_roles : {
        schema = schema_name
        role   = role
      }
    ]
  ])

  select_role_assignments_map = {
    for item in local.select_grants :
      "${item.schema}.SEL_TO_${item.role}" => {
        db_role_to_grant_fqn = snowflake_database_role.database_roles["${item.schema}.SEL"].fully_qualified_name
        parent_account_role  = item.role
      }
  }

  bi_grants = flatten([
    for schema_name, conf in var.schemas : [
      for role in conf.assign_bi_roles : {
        schema = schema_name
        role   = role
      }
    ]
  ])

  bi_role_assignments_map = {
    for item in local.bi_grants :
      "${item.schema}.BI_TO_${item.role}" => {
        db_role_to_grant_fqn = snowflake_database_role.database_roles["${item.schema}.BI"].fully_qualified_name
        parent_account_role  = item.role
      }
  }

  db_roles_list = flatten([
    for schema_key, schema_config in var.schemas: [
      for role_suffix in local.role_type_suffixes : {
        map_key = "${schema_key}.${role_suffix}"
        db_name = var.database_name
        schema_name = schema_key
        role_suffix = role_suffix
        full_role_name = "DB_${upper(var.database_name)}_${upper(schema_key)}_${role_suffix}_ROL"
      }
    ]
  ])

  db_role_definitions = {
    for item in local.db_roles_list : item.map_key => {
      db_name        = item.db_name
      schema_name    = item.schema_name
      role_suffix    = item.role_suffix
      full_role_name = item.full_role_name
    }
  }

}
