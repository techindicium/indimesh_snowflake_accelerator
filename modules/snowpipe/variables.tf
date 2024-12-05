variable "stage_name" {
    description = "Name of the stage."
    type = string
    default = null
}

variable "database_name" {
  description = "Name of the database."
  type        = string
  default     = null
}

variable "pipe_name" {
  description = "Name of the pipe."
  type        = string
  default     = null
}

variable "sns_topic" {
  description = "Notification Channel."
  type        = string
  default     = null
}

variable "schema_name" {
  description = "Name of the schema."
  type        = string
  default     = null
}

variable "table_name" {
  description = "Name of the schema."
  type        = string
  default     = null
}