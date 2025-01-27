resource "snowflake_pipe" "pipe" {
  provider                    = snowflake.sys_admin
  
  name                        = var.name
  database                    = var.database
  schema                      = var.schema

  auto_ingest                 = var.auto_ingest    
  aws_sns_topic_arn           = var.aws_sns_topic_arn

  copy_statement              = var.copy_statement
}