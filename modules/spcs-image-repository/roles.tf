resource "snowflake_grant_privileges_to_account_role" "grant_read" {
  provider = snowflake.security_admin
  for_each = toset(var.read_roles)

  account_role_name = each.key
  privileges        = ["READ"]

  on_schema_object {
    object_type = "IMAGE REPOSITORY"
    object_name = snowflake_image_repository.this.fully_qualified_name
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_write" {
  provider = snowflake.security_admin
  for_each = toset(var.write_roles)

  account_role_name = each.key
  privileges        = ["READ", "WRITE"]

  on_schema_object {
    object_type = "IMAGE REPOSITORY"
    object_name = snowflake_image_repository.this.fully_qualified_name
  }
}