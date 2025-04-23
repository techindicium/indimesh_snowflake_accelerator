variable "database_name" {
  description = "Name of the business database."
  type        = string
  default     = null
}

variable "schemas" {
  description = "Mapping schemas and functions to the database"
  type = map(object({
    assign_manage_roles = list(string)
    assign_create_roles = list(string)
    assign_select_roles = list(string)
    assign_bi_roles     = list(string)
  }))
}
