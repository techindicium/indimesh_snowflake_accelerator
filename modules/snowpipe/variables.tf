variable "name" {
  type        = string
  description = "Name of the Snowflake pipe."
}

variable "database" {
  type        = string
  description = "Name of the Snowflake database."
}

variable "schema" {
  type        = string
  description = "Name of the Snowflake schema."
}

variable "auto_ingest" {
  type        = bool
  description = "Enable auto ingestion for the pipe."
}

variable "aws_sns_topic_arn" {
  type        = string
  description = "ARN of the AWS SNS topic for notifications."
}

variable "copy_statement" {
  type        = string
  description = "Custom COPY statement for the pipe."
}

variable "warehouse" {
  type        = string
  description = "Warehouse name used by Snowflake alert."
  default     = null
}

variable "email" {
  type        = string
  description = "Email to which the snowpipe error alert will be sent."
  default     = null
}

variable "alert" {
  type        = bool
  description = "Variable that defines whether or not the alert will be created for Snowpipes."
  default     = false
}
