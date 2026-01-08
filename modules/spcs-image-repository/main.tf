resource "snowflake_image_repository" "this" {
  provider = snowflake.sys_admin

  database = var.database_name
  schema   = var.schema_name
  name     = var.image_repository_name
}