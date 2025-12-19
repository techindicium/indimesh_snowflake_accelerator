variable "compute_pool_name" {
  description = "Name of the compute pool"
  type        = string
}

variable "min_nodes" {
  description = "Minimum number of nodes"
  type        = number
}

variable "max_nodes" {
  description = "Maximum number of nodes"
  type        = number
}

variable "instance_family" {
  description = "Instance family for the compute pool"
  type        = string
}

variable "auto_resume" {
  description = "Enable auto resume"
  type        = bool
  default     = true
}

variable "initially_suspended" {
  description = "Whether the compute pool starts suspended"
  type        = bool
  default     = true
}

variable "auto_suspend_secs" {
  description = "Seconds to auto suspend"
  type        = number
  default     = 300
}

variable "usage_roles" {
  description = "List of roles to grant USAGE on the compute pool"
  type        = list(string)
}

variable "all_privileges_roles" {
  description = "List of roles to grant ALL PRIVILEGES on the compute pool"
  type        = list(string)
}