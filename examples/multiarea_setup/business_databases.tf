# # # --------------  DATABASES
module "business_databases" {
  source   = "../../modules/business-database"
  for_each = local.config.business_databases

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin  
    snowflake.security_admin   = snowflake.security_admin
    snowsql.sys_admin        = snowsql.sys_admin
    snowsql.security_admin   = snowsql.security_admin
  }
  
  database_name = each.value.database_name
  comment = each.value.database_comment
  data_retention_time_in_days = each.value.data_retention_time_in_days
  staging_schema_data_retention_days = each.value.staging_schema_data_retention_days
  

  
  # Iterate all roles created with custom_role module and return only those included in the
  # assign_manage_roles, assign_create_roles, assign_select_roles and assign_br_roles configs

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


