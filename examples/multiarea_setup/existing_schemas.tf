locals {
  schema_map = {
    for db_key, db_val in local.config.existing_databases : 
    db_key => [
      for schema_key, schema_val in db_val.schemas : {
        key                 = "${db_key}.${schema_key}"
        database_name       = db_val.database_name
        schema_name         = schema_val.name
        assign_manage_roles = schema_val.assign_manage_roles
        assign_create_roles = schema_val.assign_create_roles
        assign_select_roles = schema_val.assign_select_roles
        assign_bi_roles     = schema_val.assign_bi_roles
      }
    ]
  }

  schema_list = flatten(values(local.schema_map))

  schema_objects = {
    for obj in local.schema_list : obj.key => obj
  }
}

module "existing_schemas" {
  source = "../../modules/existing-schemas"

  for_each = local.schema_objects

  database_name       = each.value.database_name
  schema_name         = each.value.schema_name
  assign_manage_roles = each.value.assign_manage_roles
  assign_create_roles = each.value.assign_create_roles
  assign_select_roles = each.value.assign_select_roles
  assign_bi_roles     = each.value.assign_bi_roles

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
    snowsql.sys_admin        = snowsql.sys_admin
    snowsql.security_admin   = snowsql.security_admin
  }
}
