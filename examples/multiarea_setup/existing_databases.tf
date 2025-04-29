
module "existing_databases" {
  source   = "./modules/existing-database"
  for_each = local.config.existing_databases

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
  }

  database_name = each.value.database_name

  assign_manage_roles = [
    for index, custom_role in module.custom_roles : custom_role.custom_role_name
    if contains(each.value.assign_manage_roles, custom_role.custom_role_name)
  ]

  assign_create_roles = [
    for index, custom_role in module.custom_roles : custom_role.custom_role_name
    if contains(each.value.assign_create_roles, custom_role.custom_role_name)
  ]

  assign_select_roles = [
    for index, custom_role in module.custom_roles : custom_role.custom_role_name
    if contains(each.value.assign_select_roles, custom_role.custom_role_name)
  ]

  assign_bi_roles = [
    for index, custom_role in module.custom_roles : custom_role.custom_role_name
    if contains(each.value.assign_bi_roles, custom_role.custom_role_name)
  ]
}


locals {
  existing_legacy_schema_configs = {
    for pair in flatten([
      for db_name, db_config in local.config.existing_databases : [
        for schema_name, schema_config in db_config.legacy_schemas : {
          key = "${db_name}.${schema_name}"
          value = {
            database_name       = db_config.database_name
            schema_name         = schema_name
            assign_manage_roles = schema_config.assign_manage_roles
            assign_create_roles = schema_config.assign_create_roles
            assign_select_roles = schema_config.assign_select_roles
            assign_bi_roles     = schema_config.assign_bi_roles
          }
        }
      ]
    ]) : pair.key => pair.value
  }

  existing_schema_configs = {
    for pair in flatten([
      for db_name, db_config in local.config.existing_databases : [
        for schema_name, schema_config in db_config.schemas : {
          key = "${db_name}.${schema_name}"
          value = {
            database_name       = db_config.database_name
            schema_name         = schema_name
            assign_manage_roles = schema_config.assign_manage_roles
            assign_create_roles = schema_config.assign_create_roles
            assign_select_roles = schema_config.assign_select_roles
            assign_bi_roles     = schema_config.assign_bi_roles
          }
        }
      ]
    ]) : pair.key => pair.value
  }
}

module "existing_legacy_schemas" {
  source   = "./modules/existing-schemas"
  for_each = local.existing_legacy_schema_configs

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
  }

  schema        = each.value.schema_name
  database_name = each.value.database_name

  assign_manage_roles = [
    for index, custom_role in module.custom_roles : custom_role.custom_role_name
    if contains(each.value.assign_manage_roles, custom_role.custom_role_name)
  ]

  assign_create_roles = [
    for index, custom_role in module.custom_roles : custom_role.custom_role_name
    if contains(each.value.assign_create_roles, custom_role.custom_role_name)
  ]

  assign_select_roles = [
    for index, custom_role in module.custom_roles : custom_role.custom_role_name
    if contains(each.value.assign_select_roles, custom_role.custom_role_name)
  ]

  assign_bi_roles = [
    for index, custom_role in module.custom_roles : custom_role.custom_role_name
    if contains(each.value.assign_bi_roles, custom_role.custom_role_name)
  ]
}

module "existing_schemas" {
  source   = "./modules/business-schemas"
  for_each = local.existing_schema_configs

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
  }

  schema        = each.value.schema_name
  database_name = each.value.database_name

  assign_manage_roles = [
    for index, custom_role in module.custom_roles : custom_role.custom_role_name
    if contains(each.value.assign_manage_roles, custom_role.custom_role_name)
  ]

  assign_create_roles = [
    for index, custom_role in module.custom_roles : custom_role.custom_role_name
    if contains(each.value.assign_create_roles, custom_role.custom_role_name)
  ]

  assign_select_roles = [
    for index, custom_role in module.custom_roles : custom_role.custom_role_name
    if contains(each.value.assign_select_roles, custom_role.custom_role_name)
  ]

  assign_bi_roles = [
    for index, custom_role in module.custom_roles : custom_role.custom_role_name
    if contains(each.value.assign_bi_roles, custom_role.custom_role_name)
  ]
}
