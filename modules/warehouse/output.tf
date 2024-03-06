output "warehouse_name" {
  value = snowflake_warehouse.warehouse.name
}

output "warehouse_size" {
  value = snowflake_warehouse.warehouse.warehouse_size
}

output "warehouse_role_name" {
  value = module.warehouse_custom_role.custom_role_name
}