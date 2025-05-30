variable "stage_schema_name" {
  description = "schema naming."
  type        = string
  default     = "STAGES_DB"
}

variable "file_format" {
  description = "file format."
  type        = string
  default     = null
}

variable "format_null" {
  description = "null format"
  type        = list(any)
  default     = ["NULL", "null"]
}

variable "external_stage_name" {
  description = "stage name"
  type        = string
  default     = "STAGESEXT"
}

variable "file_format_name" {
  description = "Name of the file format."
  type        = string
  default     = null
}

variable "database_name" {
  description = "Name of the database."
  type        = string
  default     = null
}

variable "schema_name" {
  description = "Name of the schema"
  type = string
  default = null
}

variable "table_name" {
  description = "Name of the schema."
  type        = string
  default     = null
}

variable "storage_integration" {
  description = "Name of the Storage Integration."
  type        = string
  default     = "POCDEV_STORAGE_INTEGRATION"
}

variable "url_s3" {
  description = "URL to the stage integration."
  type        = string
  default     = null
}

variable "stage_name" {
  description = "Name of the stage."
  type        = string
  default     = null
}
