resource "snowflake_grant_privileges_to_account_role" "grant_usage" {
  provider = snowflake.security_admin
  for_each = toset(var.usage_roles)

  account_role_name = each.key
  privileges        = ["USAGE"]

  on_account_object {
    object_type = "COMPUTE POOL"
    object_name = snowflake_compute_pool.this.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_all_privileges" {
  provider = snowflake.security_admin
  for_each = toset(var.all_privileges_roles)

  account_role_name = each.key
  privileges        = ["ALL PRIVILEGES"]

  on_account_object {
    object_type = "COMPUTE POOL"
    object_name = snowflake_compute_pool.this.name
  }
}