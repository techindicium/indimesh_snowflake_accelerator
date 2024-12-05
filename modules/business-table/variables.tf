variable "database_name" {
  description = "Name of the database."
  type = string
  default = "BRONZE_DB"
}

variable "table_name" {
    description = "The name of the tables"
    type = string
    default = null
}

# variable "tables_path" {
#   description = "The path of the various tables utilized on the config file."
#   type = string
#   # default = "data/${var.table_name}.json"
# }

#"data/tables_config.json"