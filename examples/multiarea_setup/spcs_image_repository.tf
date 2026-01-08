module "spcs_image_repositories" {
  source   = "../../modules/spcs-image-repository"
  for_each = local.config.spcs_image_repositories

  image_repository_name = each.value.image_repository_name
  database_name         = each.value.database_name
  schema_name           = each.value.schema_name
  read_roles            = try(each.value.read_roles, [])
  write_roles           = try(each.value.write_roles, [])

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
  }

  depends_on = [
    module.business_databases
  ]

}