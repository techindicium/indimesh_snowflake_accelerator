locals {
  manage_grants = flatten([
    for schema_name, conf in var.schemas : [
      for role in conf.assign_manage_roles : {
        schema = schema_name
        role   = role
      }
    ]
  ])

  create_grants = flatten([
    for schema_name, conf in var.schemas : [
      for role in conf.assign_create_roles : {
        schema = schema_name
        role   = role
      }
    ]
  ])

  select_grants = flatten([
    for schema_name, conf in var.schemas : [
      for role in conf.assign_select_roles : {
        schema = schema_name
        role   = role
      }
    ]
  ])

  bi_grants = flatten([
    for schema_name, conf in var.schemas : [
      for role in conf.assign_bi_roles : {
        schema = schema_name
        role   = role
      }
    ]
  ])
}
