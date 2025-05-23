variable "warehouse_name" {
  description = "Machine name provisioned in Snowflake."
  type        = string
  default     = null
}

variable "warehouse_size" {
  description = "Machine size provisioned in Snowflake"
  type        = string
  default     = null
}

variable "warehouse_role" {
  description = "Machine size provisioned in Snowflake"
  type        = string
  default     = null
}

variable "auto_suspend" {
  description = "Specifies the number of seconds of inactivity after which a warehouse is automatically suspended"
  type        = number
  default     = 300
}

variable "enable_query_acceleration" {
  description = "Speeds up query processing"
  type        = bool
  default     = false
}

variable "max_cluster_count" {
  description = "Maximum capacity to use server groups"
  type        = number
  default     = 1
}

variable "max_concurrency_level" {
  description = "Number of queries being executed in parallel by the same warehouse"
  type        = number
  default     = 1
}

variable "query_acceleration_max_scale_factor" {
  description = "Number of allocated instances, the maximum values is 10"
  type        = number
  default     = 0
}

variable "statement_queued_timeout_in_seconds" {
  description = "Maximum time a SQL statement is queued before being canceled"
  type        = number
  default     = 300
}

variable "statement_timeout_in_seconds" {
  description = "Specifies the time, in seconds, after which a running SQL statement is canceled by the system"
  type        = number
  default     = 300
}

variable "scaling_policy" {
  description = "Specifies the policy for automatically starting and shutting down clusters in a multi-cluster warehouse running in Auto-scale mode"
  type        = string
  default     = "null"
}

variable "create_optional_resource" {
  description = "Controls whether to create the optional resource"
  type        = bool
  default     = false
}

variable "env" {
  description = "Controls whether to create the optional resource"
  type        = string
  default     = null
}

variable "assign_warehouse_role_to_roles" {
  description = "Roles to assignt the warehouse operate role to."
  type        = list
  default     = []
}

variable "auto_resume" {
  description = "Should the warehouse autoresume on queries."
  type        = bool
  default     = true
}
