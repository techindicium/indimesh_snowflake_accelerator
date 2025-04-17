resource "snowflake_alert" "pipe_failure" {
  provider = snowflake.sys_admin
  count    = var.alert ? 1 : 0

  name      = "${var.name}_FAILURE_ALERT"
  database  = var.database
  schema    = var.schema
  warehouse = var.warehouse

  alert_schedule {
    interval = 60
  }

  condition = <<-SQL
    SELECT COUNT(*) FROM SNOWFLAKE.ACCOUNT_USAGE.PIPE_HISTORY
    WHERE pipe_name = '${var.name}' 
      AND error_count > 0
      AND start_time > DATEADD(hour, -1, CURRENT_TIMESTAMP())
  SQL

  action = <<-SQL
    CALL SYSTEM$SEND_EMAIL(
      'my_email_integration', 
      '${var.email}', 
      'Pipe ${var.name} failed', 
      'The pipe has had {COUNT} errors in the last hour.'
    )
  SQL
}
