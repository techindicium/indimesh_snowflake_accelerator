# ---------------------------------------- #
#   1 - CREATING DATABASE ROLES            #
# ---------------------------------------- #
resource "snowflake_database_role" "database_roles" {
  for_each = local.db_role_definitions

  provider = snowflake.sys_admin
  database = each.value.db_name

  name = each.value.full_role_name
}

# ---------------------------------------- #
#  2 - CREATING DATABASE ROLES HIERARCHY   #
# ---------------------------------------- #
resource "snowflake_grant_database_role" "grant_crt_to_mng_role" {
  provider = snowflake.sys_admin
  for_each = var.schemas

  database_role_name = snowflake_database_role.database_roles["${each.key}.CRT"].fully_qualified_name
  parent_database_role_name   = snowflake_database_role.database_roles["${each.key}.MNG"].fully_qualified_name

  depends_on = [snowflake_database_role.database_roles]
}

resource "snowflake_grant_database_role" "grant_sel_to_crt_role" {
  provider = snowflake.sys_admin
  for_each = var.schemas

  database_role_name = snowflake_database_role.database_roles["${each.key}.SEL"].fully_qualified_name
  parent_database_role_name = snowflake_database_role.database_roles["${each.key}.CRT"].fully_qualified_name

  depends_on = [snowflake_database_role.database_roles]
}

resource "snowflake_grant_database_role" "grant_bi_to_sel_role" {
  provider = snowflake.sys_admin
  for_each = var.schemas

  database_role_name = snowflake_database_role.database_roles["${each.key}.BI"].fully_qualified_name
  parent_database_role_name   = snowflake_database_role.database_roles["${each.key}.SEL"].fully_qualified_name

  depends_on = [snowflake_database_role.database_roles]
}

# ---------------------------------------- #
#  3 - PRIVILEGES TO MANAGE DATABASE ROLE  #
# ---------------------------------------- #
resource "snowflake_grant_privileges_to_database_role" "grants_mng_role_all_on_schema" {
  provider = snowflake.sys_admin
  for_each = var.schemas

  database_role_name = snowflake_database_role.database_roles["${each.key}.MNG"].fully_qualified_name
  all_privileges     = true
  on_schema {
    schema_name = "${var.database_name}.${each.key}"
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_mng_role_all_on_tables_in_schema" {
  provider = snowflake.sys_admin
  for_each = var.schemas

  database_role_name = snowflake_database_role.database_roles["${each.key}.MNG"].fully_qualified_name
  all_privileges     = true
  on_schema_object {
    all { // Aplica a todas as tabelas (existentes e futuras) dentro do schema
      object_type_plural = "TABLES"
      in_schema          = "${var.database_name}.${each.key}"
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_stage_privileges_to_manage_role" {
  provider = snowflake.sys_admin
  for_each = var.schemas

  database_role_name = snowflake_database_role.database_roles["${each.key}.MNG"].fully_qualified_name
  all_privileges     = true
  on_schema_object {
    all {
      object_type_plural = "STAGES"
      in_schema = "${var.database_name}.${each.key}"
    }
  }
}

# ---------------------------------------- #
#  4 - PRIVILEGES ON CREATE DATABASE ROLE  #
# ---------------------------------------- #
resource "snowflake_grant_privileges_to_database_role" "grants_create_role" {
  provider = snowflake.sys_admin
  for_each = var.schemas

  database_role_name = snowflake_database_role.database_roles["${each.key}.CRT"].fully_qualified_name
  privileges         = ["USAGE", "CREATE TABLE"]
  on_schema {
    schema_name = "${var.database_name}.${each.key}"
  }
}

# ---------------------------------------- #
#  5 - PRIVILEGES ON SELECT DATABASE ROLE  #
# ---------------------------------------- #
resource "snowflake_grant_privileges_to_database_role" "grants_sel_role_usage_on_schema" {
  provider = snowflake.sys_admin
  for_each = var.schemas

  database_role_name = snowflake_database_role.database_roles["${each.key}.SEL"].fully_qualified_name
  privileges         = ["USAGE"]
  on_schema {
    schema_name = "${var.database_name}.${each.key}"
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_sel_role_select_on_all_tables" {
  provider = snowflake.sys_admin
  for_each = var.schemas

  database_role_name = snowflake_database_role.database_roles["${each.key}.SEL"].fully_qualified_name
  privileges         = ["SELECT"]
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = "${var.database_name}.${each.key}"
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_sel_role_select_on_all_views" {
  provider = snowflake.sys_admin
  for_each = var.schemas

  database_role_name = snowflake_database_role.database_roles["${each.key}.SEL"].fully_qualified_name
  privileges         = ["SELECT"]
  on_schema_object {
    all {
      object_type_plural = "VIEWS"
      in_schema          = "${var.database_name}.${each.key}"
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_sel_role_select_on_all_mviews" { # Nome do recurso ligeiramente ajustado
  provider = snowflake.sys_admin
  for_each = var.schemas

  database_role_name = snowflake_database_role.database_roles["${each.key}.SEL"].fully_qualified_name
  privileges         = ["SELECT"]
  on_schema_object {
    all {
      object_type_plural = "MATERIALIZED VIEWS"
      in_schema          = "${var.database_name}.${each.key}"
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "grants_sel_role_select_on_all_ext_tables" { # Nome do recurso ligeiramente ajustado
  provider = snowflake.sys_admin
  for_each = var.schemas

  database_role_name = snowflake_database_role.database_roles["${each.key}.SEL"].fully_qualified_name
  privileges         = ["SELECT"]
  on_schema_object {
    all {
      object_type_plural = "EXTERNAL TABLES"
      in_schema          = "${var.database_name}.${each.key}"
    }
  }
}

# ---------------------------------------- #
#   6 - PRIVILEGES ON BI DATABASE ROLE     #
# ---------------------------------------- #
resource "snowflake_grant_privileges_to_database_role" "grants_bi_role_usage_schema" {
  provider = snowflake.sys_admin
  for_each = var.schemas

  database_role_name = snowflake_database_role.database_roles["${each.key}.BI"].fully_qualified_name
  privileges         = ["USAGE"]
  on_schema {
    schema_name = "${var.database_name}.${each.key}"
  }
}

# ---------------------------------------- #
#   7 - GIVE DATABASE ROLE TO OTHER ROLES  #
# ---------------------------------------- #
resource "snowflake_grant_database_role" "grant_manage_role_to_var_assigned_roles" {
  for_each = local.manage_role_assignments_map
  provider = snowflake.security_admin

  database_role_name = each.value.db_role_to_grant_fqn
  parent_role_name   = each.value.parent_account_role
}

resource "snowflake_grant_database_role" "grant_create_role_to_var_assigned_roles" {
  for_each = local.create_role_assignments_map
  provider = snowflake.security_admin

  database_role_name = each.value.db_role_to_grant_fqn
  parent_role_name   = each.value.parent_account_role
}

resource "snowflake_grant_database_role" "grant_select_role_to_var_assigned_roles" {
  for_each = local.select_role_assignments_map
  provider = snowflake.security_admin

  database_role_name = each.value.db_role_to_grant_fqn
  parent_role_name   = each.value.parent_account_role
}

resource "snowflake_grant_database_role" "grant_bi_role_to_var_assigned_roles" {
  for_each = local.bi_role_assignments_map
  provider = snowflake.security_admin

  database_role_name = each.value.db_role_to_grant_fqn
  parent_role_name   = each.value.parent_account_role
}
