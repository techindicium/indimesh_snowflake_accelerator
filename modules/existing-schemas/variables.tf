variable "schema_name" {
  description = "Schema created in the infrastructure"
  type        = string
  default     = null
}

variable "database_name" {
  description = "Name of the business database."
  type        = string
  default     = null
}


variable "assign_manage_roles" {
  description = "Roles to assign the manage/full roles to."
  type        = list
  default     = []
}

variable "assign_create_roles" {
  description = "Roles to assign the create/write roles to."
  type        = list
  default     = []
}

variable "assign_select_roles" {
  description = "Roles to assign the select/readonly roles to."
  type        = list
  default     = []
}

variable "assign_bi_roles" {
  description = "Roles to assign the select/readonly on marts schemas roles to."
  type        = list
  default     = []
}


