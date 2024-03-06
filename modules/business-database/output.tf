output "select_role_name" {
  value = module.select_custom_role.custom_role_name
}

output "create_role_name" {
  value = module.create_custom_role.custom_role_name
}

output "database_name" {
  value = snowflake_database.database.name
}

output "bi_role_name" {
  value = try(module.bi_custom_role[0].custom_role_name, "")
}

output "manage_role_name" {
  value = module.manage_custom_role.custom_role_name
}