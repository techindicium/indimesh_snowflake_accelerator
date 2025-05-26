terraform {
  required_providers {
    snowflake = {
      source                = "Snowflake-Labs/snowflake"
      version               = "0.98.0"
      configuration_aliases = [snowflake.sys_admin, snowflake.security_admin]
    }
    snowsql = {
      source                = "aidanmelen/snowsql"
      version               = "1.3.3"
      configuration_aliases = [snowsql.sys_admin, snowsql.security_admin]
    }
  }
}

locals {
  db_name = var.database_name
}

module "manage_custom_role" {
  source   = "../custom-role"

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
    snowsql.sys_admin        = snowsql.sys_admin
    snowsql.security_admin   = snowsql.security_admin
  }
  
  custom_role_name = "DB_${local.db_name}_MNG_ROL"
  inherit_sysadmin = true

}

module "create_custom_role" {
  source   = "../custom-role"

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
    snowsql.sys_admin        = snowsql.sys_admin
    snowsql.security_admin   = snowsql.security_admin
  }
  
  custom_role_name = "DB_${local.db_name}_CRT_ROL"
  inherit_sysadmin = false

}

module "select_custom_role" {
  source   = "../custom-role"

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
    snowsql.sys_admin        = snowsql.sys_admin
    snowsql.security_admin   = snowsql.security_admin
  }
  
  custom_role_name = "DB_${local.db_name}_SEL_ROL"
  inherit_sysadmin = false

}

module "bi_custom_role" {
  source   = "../custom-role"
  count =  var.create_bi_role ? 1 : 0

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin
    snowflake.security_admin = snowflake.security_admin
    snowsql.sys_admin        = snowsql.sys_admin
    snowsql.security_admin   = snowsql.security_admin
  }
  
  custom_role_name = "DB_${local.db_name}_BI_ROL"
  inherit_sysadmin = false

}

resource "snowflake_database_role" "bi_custom_role" {
  provider = snowflake.sys_admin
  database = local.db_name
  name     = module.bi_custom_role[0].custom_role_name
}

resource "snowflake_database_role" "select_custom_role" {
  provider = snowflake.sys_admin
  database = local.db_name
  name     = module.select_custom_role.custom_role_name
}

resource "snowflake_database_role" "create_custom_role" {
  provider = snowflake.sys_admin
  database = local.db_name
  name     = module.create_custom_role.custom_role_name
}

resource "snowflake_database_role" "manage_custom_role" {
  provider = snowflake.sys_admin
  database = local.db_name
  name     = module.manage_custom_role.custom_role_name
}

resource "snowflake_grant_database_role" "grant_create_to_manage_role" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.create_custom_role.fully_qualified_name
  parent_role_name   = snowflake_database_role.manage_custom_role.name
}

resource "snowflake_grant_database_role" "grant_select_to_create_role" {
  count    = var.create_bi_role ? 1 : 0
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.select_custom_role.fully_qualified_name
  parent_role_name   = snowflake_database_role.create_custom_role.name
}

resource "snowflake_grant_database_role" "grant_bi_to_select_role" {
  count    = var.create_bi_role ? 1 : 0
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.bi_custom_role.fully_qualified_name
  parent_role_name   = snowflake_database_role.select_custom_role.name
}

resource "snowflake_grant_privileges_to_database_role" "grants_mng_role_usage_db" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.manage_custom_role.fully_qualified_name
  privileges         = ["USAGE"]
  on_database        = snowflake_database_role.manage_custom_role.database
}

resource "snowflake_grant_privileges_to_database_role" "grants_mng_role_all_privileges_schemas_future" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.manage_custom_role.fully_qualified_name
  all_privileges     = true
  on_schema {
    future_schemas_in_database = snowflake_database_role.manage_custom_role.database
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_mng_role_all_privileges_schemas_all" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.manage_custom_role.fully_qualified_name
  all_privileges     = true
  on_schema {
    all_schemas_in_database = snowflake_database_role.manage_custom_role.database
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_mng_role_all_privileges_tables_all" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.manage_custom_role.fully_qualified_name
  all_privileges     = true
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_database        = snowflake_database_role.manage_custom_role.database
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_mng_role_all_privileges_tables_future" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.manage_custom_role.fully_qualified_name
  all_privileges     = true
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_database        = snowflake_database_role.manage_custom_role.database
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_create_role" {
  provider = snowflake.security_admin
  database_role_name = snowflake_database_role.create_custom_role.fully_qualified_name
  privileges         = ["USAGE", "CREATE SCHEMA"]
  on_database        = snowflake_database_role.create_custom_role.database
}

resource "snowflake_grant_privileges_to_database_role" "grants_select_role_usage_db" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.select_custom_role.fully_qualified_name
  privileges         = ["USAGE"]
  on_database        = snowflake_database_role.select_custom_role.database
}

resource "snowflake_grant_privileges_to_database_role" "grants_select_role_usage_schema_future" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.select_custom_role.fully_qualified_name
  privileges         = ["USAGE"]
  on_schema {
    future_schemas_in_database = snowflake_database_role.select_custom_role.database
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_select_role_usage_schema_all" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.select_custom_role.fully_qualified_name
  privileges         = ["USAGE"]
  on_schema {
    all_schemas_in_database = snowflake_database_role.select_custom_role.database
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_select_role_select_tables_future" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.select_custom_role.fully_qualified_name
  privileges         = ["SELECT"]
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_database        = snowflake_database_role.select_custom_role.database
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_select_role_select_tables_all" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.select_custom_role.fully_qualified_name
  privileges         = ["SELECT"]
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_database        = snowflake_database_role.select_custom_role.database
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_select_role_select_views_future" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.select_custom_role.fully_qualified_name
  privileges         = ["SELECT"]
  on_schema_object {
    future {
      object_type_plural = "VIEWS"
      in_database        = snowflake_database_role.select_custom_role.database
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_select_role_select_views_all" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.select_custom_role.fully_qualified_name
  privileges         = ["SELECT"]
  on_schema_object {
    all {
      object_type_plural = "VIEWS"
      in_database        = snowflake_database_role.select_custom_role.database
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_select_role_select_materialized_views_future" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.select_custom_role.fully_qualified_name
  privileges         = ["SELECT"]
  on_schema_object {
    future {
      object_type_plural = "MATERIALIZED VIEWS"
      in_database        = snowflake_database_role.select_custom_role.database
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_select_role_select_materialized_views_all" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.select_custom_role.fully_qualified_name
  privileges         = ["SELECT"]
  on_schema_object {
    all {
      object_type_plural = "MATERIALIZED VIEWS"
      in_database        = snowflake_database_role.select_custom_role.database
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_select_role_select_external_tables_future" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.select_custom_role.fully_qualified_name
  privileges         = ["SELECT"]
  on_schema_object {
    future {
      object_type_plural = "EXTERNAL TABLES"
      in_database        = snowflake_database_role.select_custom_role.database
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_select_role_select_external_tables_all" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.select_custom_role.fully_qualified_name
  privileges         = ["SELECT"]
  on_schema_object {
    all {
      object_type_plural = "EXTERNAL TABLES"
      in_database        = snowflake_database_role.select_custom_role.database
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_bi_role" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.bi_custom_role.fully_qualified_name
  privileges         = ["USAGE"]
  on_database        = snowflake_database_role.bi_custom_role.database
}

resource "snowflake_grant_database_role" "grant_manage_role_to_var_assigned_roles" {
  provider = snowflake.security_admin

  for_each = {
    for index, role in var.assign_manage_roles :
    role => role
  }

  database_role_name = snowflake_database_role.manage_custom_role.fully_qualified_name
  parent_role_name = each.key
}

resource "snowflake_grant_database_role" "grant_create_role_to_var_assigned_roles" {
  provider = snowflake.security_admin
  for_each = {
    for index, role in var.assign_create_roles :
    role => role
  }

  database_role_name = snowflake_database_role.create_custom_role.fully_qualified_name
  parent_role_name = each.key
}

resource "snowflake_grant_database_role" "grant_select_role_to_var_assigned_roles" {
  provider = snowflake.security_admin
  for_each = {
    for index, role in var.assign_select_roles :
    role => role
  }

  database_role_name = snowflake_database_role.select_custom_role.fully_qualified_name
  parent_role_name = each.key
}

resource "snowflake_grant_database_role" "grant_bi_role_to_var_assigned_roles" {
  provider = snowflake.security_admin
  for_each = {
    for index, role in var.assign_bi_roles :
    role => role
  }

  database_role_name = snowflake_database_role.bi_custom_role.fully_qualified_name
  parent_role_name = each.key
}

resource "snowflake_grant_privileges_to_database_role" "grants_stage_privileges_to_manage_role_future" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.manage_custom_role.fully_qualified_name
  all_privileges     = true
  on_schema_object {
    future {
      object_type_plural = "STAGES"
      in_database        = snowflake_database_role.select_custom_role.database
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_stage_privileges_to_manage_role_all" {
  provider = snowflake.security_admin

  database_role_name = snowflake_database_role.manage_custom_role.fully_qualified_name
  all_privileges     = true
  on_schema_object {
    all {
      object_type_plural = "STAGES"
      in_database        = snowflake_database_role.select_custom_role.database
    }
  }
}
