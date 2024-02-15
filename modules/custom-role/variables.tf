variable "custom_role_name" {
  description = "Name of the custom role."
  type        = string
  default     = null
}

variable "inherit_sysadmin" {
  description = "Inherit from sysadmin role."
  type        = bool
  default     = true
}

