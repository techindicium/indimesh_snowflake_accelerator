import input

snowflake_warehouse[attributes] {
  input.resource_changes[_].type == "snowflake_warehouse"
  attributes := {
    "warehouse_name": input.resource_changes[_].change.after.warehouse_name,
    "warehouse_size ": input.resource_changes[_].change.after.warehouse_size,
    "enable_query_acceleration ": input.resource_changes[_].change.after.enable_query_acceleration
  }
}

snowflake_database[attributes] {
  input.resource_changes[_].type == "snowflake_database"
  attributes := {
    "data_retention_time_in_days": input.resource_changes[_].change.after.data_retention_time_in_days,
    "is_transient": input.resource_changes[_].change.after.name
  }
}

snowflake_schema[attributes] {
  input.resource_changes[_].type == "snowflake_schema"
  attributes := {
    "warehouse_name": input.resource_changes[_].change.after.warehouse_name,
    "privilege": input.resource_changes[_].change.after.privilege
  }
}

snowflake_role[attributes] {
  input.resource_changes[_].type == "snowflake_role"
  attributes := {
    "role_name": input.resource_changes[_].change.after.name,
  }
}

snowflake_warehouse_grant[attributes] {
  input.resource_changes[_].type == "snowflake_warehouse_grant"
  attributes := {
    "privilege": input.resource_changes[_].change.after.privilege
  }
}

snowflake_database_grant[attributes] {
  input.resource_changes[_].type == "snowflake_database_grant"
  attributes := {
    "privilege": input.resource_changes[_].change.after.privilege
  }