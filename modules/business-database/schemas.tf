#
# module "schema_create_custom_role" {
#   source   = "../custom-role"
#   providers = {
#     snowflake.sys_admin      = snowflake.sys_admin
#     snowflake.security_admin = snowflake.security_admin
#   }
#
#   for_each = {
#     for schema_name, config in var.schemas :
#     schema_name => config
#     if try(length(config.assign_create_roles), 0) > 0
#   }
#
#
#
#   custom_role_name = "DB_${local.db_name}_${each.key}_CRT_ROL"
#   inherit_sysadmin = false
#
#   depends_on = [snowflake_database.database]
# }
#
#
# resource "snowflake_grant_privileges_to_database_role" "grant_create_role_usage_and_create_schema" {
#   for_each = {
#     for schema_name, config in var.schemas :
#     schema_name => config
#     if try(length(config.assign_create_roles), 0) > 0
#   }
#
#   provider = snowflake.security_admin
#
#   database_role_name = module.schema_create_custom_role[each.key].custom_role_name
#   privileges         = ["USAGE", "CREATE TABLE", "CREATE VIEW", "CREATE STAGE", "CREATE FUNCTION"]
#
#   on_schema {
#     schema_name = snowflake_schema.business_schemas[each.key].fully_qualified_name
#   }
# }
