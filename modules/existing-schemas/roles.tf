
module "schema_manage_custom_role" {
  source   = "../custom-role"
  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
  }

  custom_role_name = "DB_${local.db_name}_${local.schema_name}_MNG_ROL"
  inherit_sysadmin = false
}

module "schema_create_custom_role" {
  source   = "../custom-role"
  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
  }

  custom_role_name = "DB_${local.db_name}_${local.schema_name}_CRT_ROL"
  inherit_sysadmin = false
}

module "schema_select_custom_role" {
  source   = "../custom-role"
  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
  }

  custom_role_name = "DB_${local.db_name}_${local.schema_name}_SEL_ROL"
  inherit_sysadmin = false
}

module "schema_bi_custom_role" {
  source   = "../custom-role"
  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
  }

  custom_role_name = "DB_${local.db_name}_${local.schema_name}_BI_ROL"
  inherit_sysadmin = false
}


resource "snowflake_database_role" "schema_bi_custom_role" {
  provider = snowflake.sys_admin
  database = local.db_name
  name     = module.schema_bi_custom_role.custom_role_name
}

resource "snowflake_database_role" "schema_select_custom_role" {
  provider = snowflake.sys_admin
  database = local.db_name
  name     = module.schema_select_custom_role.custom_role_name
}

resource "snowflake_database_role" "schema_create_custom_role" {
  provider = snowflake.sys_admin
  database = local.db_name
  name     = module.schema_create_custom_role.custom_role_name
}

resource "snowflake_database_role" "schema_manage_custom_role" {
  provider = snowflake.sys_admin
  database = local.db_name
  name     = module.schema_manage_custom_role.custom_role_name
}

resource "snowflake_grant_database_role" "grant_create_to_manage_role" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.schema_create_custom_role.fully_qualified_name
  parent_role_name   = snowflake_database_role.schema_manage_custom_role.name
}

resource "snowflake_grant_database_role" "grant_select_to_create_role" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.schema_select_custom_role.fully_qualified_name
  parent_role_name   = snowflake_database_role.schema_create_custom_role.name
}

resource "snowflake_grant_database_role" "grant_bi_to_select_role" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.schema_bi_custom_role.fully_qualified_name
  parent_role_name   = snowflake_database_role.schema_select_custom_role.name
}


resource "snowflake_grant_privileges_to_database_role" "grants_mng_role_usage_schema" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.schema_manage_custom_role.fully_qualified_name
  privileges         = ["USAGE"]
  on_schema {
    schema_name = "${local.db_name}.${local.schema_name}"
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_mng_role_all_privileges_schema" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.schema_manage_custom_role.fully_qualified_name
  all_privileges     = true
  on_schema {
    schema_name = "${local.db_name}.${local.schema_name}"
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_mng_role_all_privileges_tables" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.schema_manage_custom_role.fully_qualified_name
  all_privileges     = true
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema = "${local.db_name}.${local.schema_name}"
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_create_role" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.schema_create_custom_role.fully_qualified_name
  privileges         = ["USAGE", "CREATE STAGE"]
  on_schema {
    schema_name = "${local.db_name}.${local.schema_name}"
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_select_role_usage_schema" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.schema_select_custom_role.fully_qualified_name
  privileges         = ["USAGE"]
  on_schema {
    schema_name = "${local.db_name}.${local.schema_name}"
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_select_role_select_tables" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.schema_select_custom_role.fully_qualified_name
  privileges         = ["SELECT"]
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema = "${local.db_name}.${local.schema_name}"
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_select_role_select_views" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.schema_select_custom_role.fully_qualified_name
  privileges         = ["SELECT"]
  on_schema_object {
    all {
      object_type_plural = "VIEWS"
      in_schema = "${local.db_name}.${local.schema_name}"
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_select_role_select_materialized_views" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.schema_select_custom_role.fully_qualified_name
  privileges         = ["SELECT"]
  on_schema_object {
    all {
      object_type_plural = "MATERIALIZED VIEWS"
      in_schema = "${local.db_name}.${local.schema_name}"
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_select_role_select_external_tables" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.schema_select_custom_role.fully_qualified_name
  privileges         = ["SELECT"]
  on_schema_object {
    all {
      object_type_plural = "EXTERNAL TABLES"
      in_schema = "${local.db_name}.${local.schema_name}"
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_bi_role_usage_schema" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.schema_bi_custom_role.fully_qualified_name
  privileges         = ["USAGE"]
  on_schema {
    schema_name = "${local.db_name}.${local.schema_name}"
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_stage_privileges_to_manage_role" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.schema_manage_custom_role.fully_qualified_name
  all_privileges     = true
  on_schema_object {
    all {
      object_type_plural = "STAGES"
      in_schema = "${local.db_name}.${local.schema_name}"
    }
  }
}

resource "snowflake_grant_database_role" "grant_manage_role_to_var_assigned_roles" {
  provider = snowflake.security_admin

  for_each = {
    for index, role in var.assign_manage_roles :
    role => role
  }

  database_role_name = snowflake_database_role.schema_manage_custom_role.fully_qualified_name
  parent_role_name   = each.key
}

resource "snowflake_grant_database_role" "grant_create_role_to_var_assigned_roles" {
  provider = snowflake.security_admin
  for_each = {
    for index, role in var.assign_create_roles :
    role => role
  }

  database_role_name = snowflake_database_role.schema_create_custom_role.fully_qualified_name
  parent_role_name   = each.key
}

resource "snowflake_grant_database_role" "grant_select_role_to_var_assigned_roles" {
  provider = snowflake.security_admin
  for_each = {
    for index, role in var.assign_select_roles :
    role => role
  }

  database_role_name = snowflake_database_role.schema_select_custom_role.fully_qualified_name
  parent_role_name   = each.key
}

resource "snowflake_grant_database_role" "grant_bi_role_to_var_assigned_roles" {
  provider = snowflake.security_admin
  for_each = {
    for index, role in var.assign_bi_roles :
    role => role
  }

  database_role_name = snowflake_database_role.schema_bi_custom_role.fully_qualified_name
  parent_role_name   = each.key
}
