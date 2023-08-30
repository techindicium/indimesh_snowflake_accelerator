output "warehouse_name" {
  value = snowflake_warehouse.warehouse.name
}

output "warehouse_size" {
  value = snowflake_warehouse.warehouse.warehouse_size
}

output "database_role_name" {
  value = snowflake_role.database_role.name
}

output "warehouse_role_name" {
  value = snowflake_role.warehouse_role.name
}

output "database_name" {
  value = snowflake_database.database.name
}

output "team_role_name" {
  value = snowflake_role.team_role.name
}

output "schema_name" {
  value = snowflake_schema.schema[0].name
}