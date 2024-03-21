
## Tem que dar o grant aqui tambem, nao ta funcioando só o defaultrole
resource "snowflake_user" "user" {
  provider = snowflake.security_admin
  for_each = local.config.users

  name         = each.value.name
  login_name   = each.value.login
  comment      = each.value.comment
  display_name = each.value.name
  email        = each.value.email
  first_name   = each.value.first_name
  last_name    = each.value.last_anme

  default_warehouse = module.snowflake_warehouses[each.value.default_warehouse].warehouse_name
  default_role      = module.custom_roles[each.value.default_role].custom_role_name

  # Iterate all roles created with custom_role module and return only those included in the
  # secondary_roles config

  default_secondary_roles = [
    for index, custom_role in module.custom_roles : custom_role.custom_role_name
    if contains(each.value.secondary_roles, custom_role.custom_role_name)
  ]

  must_change_password = true

  lifecycle {
    ignore_changes = [
      password,
    ]
  }
}

resource "snowsql_exec" "grant_default_role" {
  for_each = snowflake_user.user
  provider = snowsql.security_admin

  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    GRANT ROLE "${each.value.default_role}" TO USER ${each.value.name};
    EOT
  }
  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    REVOKE ROLE "${each.value.default_role}" FROM USER ${each.value.name};
    EOT
  }
}
