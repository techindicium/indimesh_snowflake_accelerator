variable "dev_db_name" {
  type        = string
  default     = "DEV_DB"
  description = "Name of development database"
}

variable "create_dev_schema" {
  type        = bool
  default     = false
  description = "Checks if the user needs a development schema creation"
}

variable "assign_public_key" {
  type        = bool
  default     = false
  description = "Checks if user needs to assign a public key"
}

variable "private_key_secret_arn" {
  type        = string
  default     = null
  description = "Private key secret arn to use on public key assigment"
}

variable "name" {
  type        = string
  default     = null
  description = "User name on database"
}

variable "login_name" {
  type        = string
  default     = null
  description = "Login to be used on snowflake account"
}

variable "comment" {
  type        = string
  default     = null
  description = "Description or comments on the user"
}

variable "email" {
  type        = string
  default     = null
  description = "User's email"
}

variable "first_name" {
  type        = string
  default     = null
  description = "User's first name"
}

variable "last_name" {
  type        = string
  default     = null
  description = "User's last name"
}

variable "warehouse_name" {
  type        = string
  default     = null
  description = "User default warehouse"
}

variable "role" {
  type        = string
  default     = null
  description = "User default role"
}

variable "roles" {
    type = list(string)
    default = []
    description = "Extra roles to add to user"
}

variable "sf_default_user_password" {
  type = string
  default = "changeME#123"
  description = "User's password"
}