resource "snowflake_service_user" "service_user" {
  provider = snowflake.security_admin  

  name         = local.name
  comment      = local.comment
  display_name = local.name

  default_warehouse = local.warehouse_name
  default_role      = local.role

  rsa_public_key = try(replace(data.tls_public_key.loader_public_key[0].public_key_pem, "/-----BEGIN PUBLIC KEY-----|\\n|-----END PUBLIC KEY-----/", ""), null)

  lifecycle {
    ignore_changes = [
      rsa_public_key
    ]
  }
}

data "aws_secretsmanager_secret" "private_key_secret" {
  count = local.assign_public_key ? 1 : 0  
  arn = local.private_key_secret_arn
}

data "aws_secretsmanager_secret_version" "private_key_version" {
  count     = local.assign_public_key ? 1 : 0
  secret_id = data.aws_secretsmanager_secret.private_key_secret[0].id
}

data "tls_public_key" "loader_public_key" {
  count           = local.assign_public_key ? 1 : 0
  private_key_pem = data.aws_secretsmanager_secret_version.private_key_version[0].secret_string
}

resource "snowsql_exec" "grant_default_role_service_user" {  
  provider = snowsql.security_admin

  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    GRANT ROLE "${local.role}" TO USER "${local.name}";
    EOT
  }
  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    REVOKE ROLE "${local.role}" FROM USER "${local.name}";
    EOT
  }
}

resource "snowflake_user" "user" {
  provider = snowflake.security_admin
  
  name         = local.name
  login_name   = local.login_name
  comment      = local.comment
  display_name = local.name
  email        = local.email
  first_name   = local.first_name
  last_name    = local.last_name

  default_warehouse = local.warehouse_name
  default_role      = try(local.role, null)

  password             = local.sf_default_user_password
  must_change_password = true
  rsa_public_key       = try(data.tls_public_key.loader_public_key[0].public_key_pem, null)

  lifecycle {
    ignore_changes = [
      password,
      must_change_password,
      rsa_public_key
    ]
  }
}

resource "snowsql_exec" "grant_default_role" {  
  provider = snowsql.security_admin

  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    GRANT ROLE "${local.role}" TO USER "${local.name}";
    EOT
  }
  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    REVOKE ROLE "${local.role}" FROM USER "${local.name}";
    EOT
  }
}

resource "snowsql_exec" "grant_extra_roles" {
  # count = length(local.roles) > 0 ? 1 : 0
  for_each = toset(local.roles)

  provider = snowsql.security_admin

  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    GRANT ROLE "${each.key}" TO USER "${local.name}";
    EOT
  }

  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    REVOKE ROLE "${each.key}" FROM USER "${local.name}";
    EOT
  }
}


resource "snowsql_exec" "grant_key_pair_association" {  
  provider = snowsql.security_admin

  depends_on = [snowflake_user.user]

  create {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    GRANT MODIFY PROGRAMMATIC AUTHENTICATION METHODS ON USER "${local.name}" TO USER "${local.name}";
    EOT
  }
  delete {
    statements = <<-EOT
    USE ROLE SECURITYADMIN;
    REVOKE MODIFY PROGRAMMATIC AUTHENTICATION METHODS ON USER "${local.name}" FROM USER "${local.name}";
    EOT
  }
}
