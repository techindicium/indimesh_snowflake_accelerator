variable "database_name" {
  description = "Snowflake database where the image repository will be created"
  type        = string
}

variable "schema_name" {
  description = "Schema where the image repository will be created"
  type        = string
}

variable "image_repository_name" {
  description = "Name of the image repository"
  type        = string
}

variable "read_roles" {
  description = "List of roles to grant READ on the image repository"
  type        = list(string)
  default     = []
}

variable "write_roles" {
  description = "List of roles to grant WRITE on the image repository"
  type        = list(string)
  default     = []
}