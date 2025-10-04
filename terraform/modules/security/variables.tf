variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name (prod, nonprod)"
  type        = string
}

variable "database_username" {
  description = "PostgreSQL database username"
  type        = string
  default     = "idurar_user"
}

variable "database_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "idurar_erp"
}

