##### 1. Grants all privileges to account roles

resource "snowflake_grant_privileges_to_account_role" "grant_manage_usage" {
  for_each = { for item in local.manage_grants : "${item.schema}-${item.role}" => item }
  provider = snowflake.security_admin

  account_role_name = each.value.role
  all_privileges    = true

  on_schema {
    schema_name = "${var.database_name}.${each.value.schema}"
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_manage_tables" {
  for_each = { for item in local.manage_grants : "${item.schema}-${item.role}" => item }
  provider = snowflake.security_admin

  account_role_name = each.value.role
  all_privileges    = true

  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = "${var.database_name}.${each.value.schema}"
    }
  }
}

##### 2. Grants read/write to account roles

resource "snowflake_grant_privileges_to_account_role" "grant_create_schema" {
  for_each = { for item in local.create_grants : "${item.schema}-${item.role}" => item }
  provider = snowflake.security_admin

  account_role_name = each.value.role
  privileges        = ["USAGE", "CREATE TABLE"]

  on_schema {
    schema_name = "${var.database_name}.${each.value.schema}"
  }
}

##### 3. Grants read to account roles

resource "snowflake_grant_privileges_to_account_role" "grant_select_usage" {
  for_each = { for item in local.select_grants : "${item.schema}-${item.role}" => item }
  provider = snowflake.security_admin

  account_role_name = each.value.role
  privileges        = ["USAGE", "SELECT"]

  on_schema {
    schema_name = "${var.database_name}.${each.value.schema}"
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_select_tables" {
  for_each = { for item in local.select_grants : "${item.schema}-${item.role}" => item }
  provider = snowflake.security_admin

  account_role_name = each.value.role
  privileges        = ["SELECT"]

  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = "${var.database_name}.${each.value.schema}"
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_select_views" {
  for_each = { for item in local.select_grants : "${item.schema}-${item.role}" => item }
  provider = snowflake.security_admin

  account_role_name = each.value.role
  privileges        = ["SELECT"]

  on_schema_object {
    all {
      object_type_plural = "VIEWS"
      in_schema          = "${var.database_name}.${each.value.schema}"
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_select_materialized_views" {
  for_each = { for item in local.select_grants : "${item.schema}-${item.role}" => item }
  provider = snowflake.security_admin

  account_role_name = each.value.role
  privileges        = ["SELECT"]

  on_schema_object {
    all {
      object_type_plural = "MATERIALIZED VIEWS"
      in_schema          = "${var.database_name}.${each.value.schema}"
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_select_external_tables" {
  for_each = { for item in local.select_grants : "${item.schema}-${item.role}" => item }
  provider = snowflake.security_admin

  account_role_name = each.value.role
  privileges        = ["SELECT"]

  on_schema_object {
    all {
      object_type_plural = "EXTERNAL TABLES"
      in_schema          = "${var.database_name}.${each.value.schema}"
    }
  }
}

##### 4. Grants usage to account roles

resource "snowflake_grant_privileges_to_account_role" "grant_bi_usage" {
  for_each = { for item in local.bi_grants : "${item.schema}-${item.role}" => item }
  provider = snowflake.security_admin

  account_role_name = each.value.role
  privileges        = ["USAGE"]

  on_schema {
    schema_name = "${var.database_name}.${each.value.schema}"
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_bi_objects" {
  for_each = { for item in local.bi_grants : "${item.schema}-${item.role}" => item }
  provider = snowflake.security_admin

  account_role_name = each.value.role
  privileges        = ["SELECT"]

  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = "${var.database_name}.${each.value.schema}"
    }
  }
}
