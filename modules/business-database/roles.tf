

module "manage_custom_role" {
  source   = "../custom-role"

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin  
    snowflake.security_admin   = snowflake.security_admin
    snowsql.sys_admin        = snowsql.sys_admin
    snowsql.security_admin   = snowsql.security_admin
  }
  
  custom_role_name = "DB_${local.db_name}_MNG_ROL"
  inherit_sysadmin = true

  depends_on = [
    snowflake_database.database
  ]
}

module "create_custom_role" {
  source   = "../custom-role"

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin  
    snowflake.security_admin   = snowflake.security_admin
    snowsql.sys_admin        = snowsql.sys_admin
    snowsql.security_admin   = snowsql.security_admin
  }
  
  custom_role_name = "DB_${local.db_name}_CRT_ROL"
  inherit_sysadmin = false

  depends_on = [
    snowflake_database.database
  ]
}

module "select_custom_role" {
  source   = "../custom-role"

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin  
    snowflake.security_admin   = snowflake.security_admin
    snowsql.sys_admin        = snowsql.sys_admin
    snowsql.security_admin   = snowsql.security_admin
  }
  
  custom_role_name = "DB_${local.db_name}_SEL_ROL"
  inherit_sysadmin = false
  depends_on = [
    snowflake_database.database
  ]
}

module "bi_custom_role" {
  source   = "../custom-role"
  count =  var.create_bi_role ? 1 : 0

  providers = {
    snowflake.sys_admin      = snowflake.sys_admin  
    snowflake.security_admin   = snowflake.security_admin
    snowsql.sys_admin        = snowsql.sys_admin
    snowsql.security_admin   = snowsql.security_admin
  }
  
  custom_role_name = "DB_${local.db_name}_BI_ROL"
  inherit_sysadmin = false

  depends_on = [
    snowflake_database.database
  ]
}

resource "snowsql_exec" "grant_create_to_manage_role" {
  provider = snowsql.security_admin
  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    GRANT ROLE "${module.create_custom_role.custom_role_name}" TO ROLE ${module.manage_custom_role.custom_role_name};
    EOT
  }
  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    REVOKE ROLE "${module.create_custom_role.custom_role_name}" FROM ROLE ${module.manage_custom_role.custom_role_name};
    EOT
  }
}

resource "snowsql_exec" "grant_select_to_create_role" {
  provider = snowsql.security_admin
  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    GRANT ROLE "${module.select_custom_role.custom_role_name}" TO ROLE ${module.create_custom_role.custom_role_name};
    EOT
  }
  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    REVOKE ROLE "${module.select_custom_role.custom_role_name}" FROM ROLE ${module.create_custom_role.custom_role_name};
    EOT
  }
}

resource "snowsql_exec" "grant_bi_to_select_role" {
  count =  var.create_bi_role ? 1 : 0
  provider = snowsql.security_admin
  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    GRANT ROLE "${module.bi_custom_role[0].custom_role_name}" TO ROLE ${module.select_custom_role.custom_role_name};
    EOT
  }
  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    REVOKE ROLE "${module.bi_custom_role[0].custom_role_name}" FROM ROLE ${module.select_custom_role.custom_role_name};
    EOT
  }
}

resource "snowsql_exec" "grants_mng_role" {
  provider = snowsql.security_admin
  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;

    GRANT USAGE ON DATABASE ${local.db_name} TO ROLE ${module.manage_custom_role.custom_role_name};

    GRANT ALL PRIVILEGES ON FUTURE SCHEMAS IN  DATABASE ${local.db_name} TO ROLE ${module.manage_custom_role.custom_role_name};
    GRANT ALL PRIVILEGES ON ALL SCHEMAS IN  DATABASE ${local.db_name} TO ROLE ${module.manage_custom_role.custom_role_name};

    GRANT ALL PRIVILEGES ON FUTURE TABLES IN DATABASE ${local.db_name} TO ROLE ${module.manage_custom_role.custom_role_name};
    GRANT ALL PRIVILEGES ON ALL TABLES IN DATABASE ${local.db_name} TO ROLE ${module.manage_custom_role.custom_role_name};
    
    EOT
  }
  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    
    REVOKE USAGE ON DATABASE ${local.db_name} FROM ROLE ${module.manage_custom_role.custom_role_name};

    REVOKE ALL PRIVILEGES ON FUTURE SCHEMAS IN  DATABASE ${local.db_name} FROM ROLE ${module.manage_custom_role.custom_role_name};
    REVOKE ALL PRIVILEGES ON ALL SCHEMAS IN  DATABASE ${local.db_name} FROM ROLE ${module.manage_custom_role.custom_role_name};

    REVOKE ALL PRIVILEGES ON FUTURE TABLES IN DATABASE ${local.db_name} FROM ROLE ${module.manage_custom_role.custom_role_name};
    REVOKE ALL PRIVILEGES ON ALL TABLES IN DATABASE ${local.db_name} FROM ROLE ${module.manage_custom_role.custom_role_name};
    
    EOT
  }
}

resource "snowsql_exec" "grants_create_role" {
  provider = snowsql.security_admin
  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
        
    GRANT USAGE ON DATABASE ${local.db_name} TO ROLE ${module.create_custom_role.custom_role_name};
    GRANT CREATE SCHEMA ON DATABASE ${local.db_name} TO ROLE ${module.create_custom_role.custom_role_name};
    
    EOT
  }
  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    
    REVOKE USAGE ON DATABASE ${local.db_name} FROM ROLE ${module.create_custom_role.custom_role_name};
    REVOKE CREATE SCHEMA ON DATABASE ${local.db_name} FROM ROLE ${module.create_custom_role.custom_role_name};
    
    EOT
  }
}

resource "snowsql_exec" "grants_select_role" {
  provider = snowsql.security_admin
  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;

    GRANT USAGE ON DATABASE ${local.db_name} TO ROLE ${module.select_custom_role.custom_role_name};

    GRANT USAGE ON FUTURE SCHEMAS IN  DATABASE ${local.db_name} TO ROLE ${module.select_custom_role.custom_role_name};
    GRANT USAGE ON ALL SCHEMAS IN  DATABASE ${local.db_name} TO ROLE ${module.select_custom_role.custom_role_name};

    GRANT SELECT ON FUTURE TABLES IN DATABASE ${local.db_name} TO ROLE ${module.select_custom_role.custom_role_name};
    GRANT SELECT ON ALL TABLES IN DATABASE ${local.db_name} TO ROLE ${module.select_custom_role.custom_role_name};

    GRANT SELECT ON FUTURE VIEWS IN DATABASE ${local.db_name} TO ROLE ${module.select_custom_role.custom_role_name};
    GRANT SELECT ON ALL VIEWS IN DATABASE ${local.db_name} TO ROLE ${module.select_custom_role.custom_role_name};

    GRANT SELECT ON FUTURE MATERIALIZED VIEWS IN DATABASE ${local.db_name} TO ROLE ${module.select_custom_role.custom_role_name};
    GRANT SELECT ON ALL MATERIALIZED VIEWS IN DATABASE ${local.db_name} TO ROLE ${module.select_custom_role.custom_role_name};

    GRANT SELECT ON FUTURE EXTERNAL TABLES IN DATABASE ${local.db_name} TO ROLE ${module.select_custom_role.custom_role_name};
    GRANT SELECT ON ALL EXTERNAL TABLES IN DATABASE ${local.db_name} TO ROLE ${module.select_custom_role.custom_role_name};
   
    EOT
  }
  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    REVOKE USAGE ON DATABASE ${local.db_name} FROM ROLE ${module.select_custom_role.custom_role_name};

    REVOKE USAGE ON FUTURE SCHEMAS IN  DATABASE ${local.db_name} FROM ROLE ${module.select_custom_role.custom_role_name};
    REVOKE USAGE ON ALL SCHEMAS IN  DATABASE ${local.db_name} FROM ROLE ${module.select_custom_role.custom_role_name};

    REVOKE SELECT ON FUTURE TABLES IN DATABASE ${local.db_name} FROM ROLE ${module.select_custom_role.custom_role_name};
    REVOKE SELECT ON ALL TABLES IN DATABASE ${local.db_name} FROM ROLE ${module.select_custom_role.custom_role_name};

    REVOKE SELECT ON FUTURE VIEWS IN DATABASE ${local.db_name} FROM ROLE ${module.select_custom_role.custom_role_name};
    REVOKE SELECT ON ALL VIEWS IN DATABASE ${local.db_name} FROM ROLE ${module.select_custom_role.custom_role_name};

    REVOKE SELECT ON FUTURE MATERIALIZED VIEWS IN DATABASE ${local.db_name} FROM ROLE ${module.select_custom_role.custom_role_name};
    REVOKE SELECT ON ALL MATERIALIZED VIEWS IN DATABASE ${local.db_name} FROM ROLE ${module.select_custom_role.custom_role_name};

    REVOKE SELECT ON FUTURE EXTERNAL TABLES IN DATABASE ${local.db_name} FROM ROLE ${module.select_custom_role.custom_role_name};
    REVOKE SELECT ON ALL EXTERNAL TABLES IN DATABASE ${local.db_name} FROM ROLE ${module.select_custom_role.custom_role_name};
    
    EOT
  }
}

resource "snowsql_exec" "grants_bi_role" {
  provider = snowsql.security_admin
  count =  var.create_bi_role ? 1 : 0

  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;

    GRANT USAGE ON DATABASE ${local.db_name} TO ROLE ${module.bi_custom_role[0].custom_role_name};
    GRANT USAGE ON SCHEMA ${local.db_name}.${snowflake_schema.marts_schema.name} TO ROLE ${module.bi_custom_role[0].custom_role_name};

    GRANT SELECT ON FUTURE TABLES IN SCHEMA ${local.db_name}.${snowflake_schema.marts_schema.name} TO ROLE ${module.bi_custom_role[0].custom_role_name};
    GRANT SELECT ON ALL TABLES IN SCHEMA ${local.db_name}.${snowflake_schema.marts_schema.name} TO ROLE ${module.bi_custom_role[0].custom_role_name};

    GRANT SELECT ON FUTURE VIEWS IN SCHEMA ${local.db_name}.${snowflake_schema.marts_schema.name} TO ROLE ${module.bi_custom_role[0].custom_role_name};
    GRANT SELECT ON ALL VIEWS IN SCHEMA ${local.db_name}.${snowflake_schema.marts_schema.name} TO ROLE ${module.bi_custom_role[0].custom_role_name};

    GRANT SELECT ON FUTURE MATERIALIZED VIEWS IN SCHEMA ${local.db_name}.${snowflake_schema.marts_schema.name} TO ROLE ${module.bi_custom_role[0].custom_role_name};
    GRANT SELECT ON ALL MATERIALIZED VIEWS IN SCHEMA ${local.db_name}.${snowflake_schema.marts_schema.name} TO ROLE ${module.bi_custom_role[0].custom_role_name};
    
    EOT
  }
  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    
    REVOKE USAGE ON DATABASE ${local.db_name} FROM ROLE ${module.bi_custom_role[0].custom_role_name};
    REVOKE USAGE ON SCHEMA ${local.db_name}.${snowflake_schema.marts_schema.name} FROM ROLE ${module.bi_custom_role[0].custom_role_name};

    REVOKE SELECT ON FUTURE TABLES IN SCHEMA ${local.db_name}.${snowflake_schema.marts_schema.name} FROM ROLE ${module.bi_custom_role[0].custom_role_name};
    REVOKE SELECT ON ALL TABLES IN SCHEMA ${local.db_name}.${snowflake_schema.marts_schema.name} FROM ROLE ${module.bi_custom_role[0].custom_role_name};

    REVOKE SELECT ON FUTURE VIEWS IN SCHEMA ${local.db_name}.${snowflake_schema.marts_schema.name} FROM ROLE ${module.bi_custom_role[0].custom_role_name};
    REVOKE SELECT ON ALL VIEWS IN SCHEMA ${local.db_name}.${snowflake_schema.marts_schema.name} FROM ROLE ${module.bi_custom_role[0].custom_role_name};

    REVOKE SELECT ON FUTURE MATERIALIZED VIEWS IN SCHEMA ${local.db_name}.${snowflake_schema.marts_schema.name} FROM ROLE ${module.bi_custom_role[0].custom_role_name};
    REVOKE SELECT ON ALL MATERIALIZED VIEWS IN SCHEMA ${local.db_name}.${snowflake_schema.marts_schema.name} FROM ROLE ${module.bi_custom_role[0].custom_role_name};
    
    EOT
  }
}

resource "snowsql_exec" "grant_manage_role_to_var_assigned_roles" {
  provider = snowsql.security_admin
  for_each   = {
    for index, role in var.assing_manage_roles:
    role => role
  }

  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    GRANT ROLE "${module.manage_custom_role.custom_role_name}" TO ROLE "${each.key}";
    EOT
  }
  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    REVOKE ROLE "${module.manage_custom_role.custom_role_name}" FROM ROLE "${each.key}";
    EOT
  }
}

resource "snowsql_exec" "grant_create_role_to_var_assigned_roles" {
  provider = snowsql.security_admin
  for_each   = {
    for index, role in var.assing_create_roles:
    role => role
  }

  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    GRANT ROLE "${module.create_custom_role.custom_role_name}" TO ROLE "${each.key}";
    EOT
  }
  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    REVOKE ROLE "${module.create_custom_role.custom_role_name}" FROM ROLE "${each.key}";
    EOT
  }
}

resource "snowsql_exec" "grant_select_role_to_var_assigned_roles" {
  provider = snowsql.security_admin
  for_each   = {
    for index, role in var.assing_select_roles:
    role => role
  }

  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    GRANT ROLE "${module.select_custom_role.custom_role_name}" TO ROLE "${each.key}";
    EOT
  }
  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    REVOKE ROLE "${module.select_custom_role.custom_role_name}" FROM ROLE "${each.key}";
    EOT
  }
}

resource "snowsql_exec" "grant_bi_role_to_var_assigned_roles" {
  provider = snowsql.security_admin
  for_each   = {
    for index, role in var.assing_bi_roles:
    role => role
  }

  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    GRANT ROLE "${module.bi_custom_role[0].custom_role_name}" TO ROLE "${each.key}";
    EOT
  }
  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    REVOKE ROLE "${module.bi_custom_role[0].custom_role_name}" FROM ROLE "${each.key}";
    EOT
  }
}