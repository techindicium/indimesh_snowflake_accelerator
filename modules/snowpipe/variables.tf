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