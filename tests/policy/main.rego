package main

import input
import data.resources

deny[msg] {
  warehouse_size := resources.snowflake_warehouse[attributes].warehouse_size
  allowed_sizes := ["X-Small", "Small", "Medium", "Large", "X-Large", "2X-Large", "3X-Large", "4X-Large", "5X-Large", "6X-Large"]
  size := allowed_sizes[_]
  size == warehouse_size
  msg := sprintf("Should set warehouse size to one of the allowed values: %v", [allowed_sizes])
}

deny[msg] {
  warehouse_name := resources.snowflake_warehouse[attributes].warehouse_name
  not warehouse_name
  msg := "Should be set warehouse size"
}

deny[msg] {
  data_retention_time_in_days := resources.snowflake_database[attributes].data_retention_time_in_days 
  not data_retention_time_in_days = 0
  msg := "Should be set 0 to avoid time travel in snowflake"
}

deny[msg] {
  db_name := resources.snowflake_database[attributes].db_name
  not db_name
  msg = "Database name should be set"
}

deny[msg] {
  warehouse_name := resources.snowflake_schema[attributes].warehouse_name
  not warehouse_name
  msg = "Warehouse name should be set"
}

deny[msg] {
  privilege := resources.snowflake_schema[attributes].privilege
  not privilege = "USAGE"
  msg = "Privilige should set as USAGE"
}

deny[msg] {
  privilege := resources.snowflake_warehouse_grant[attributes].privilege
  not privilege = "USAGE"
  msg = "Privilige should set as USAGE"
}

deny[msg] {
  privilege := resources.snowflake_database_grant[attributes].privilege
  not privilege = "USAGE"
  msg = "Privilige should set as USAGE"
}

deny[msg] {
  role_name := resources.snowflake_database_grant[attributes].role_name
  not role_name
  msg = "Role name should be set"
}