variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "idurar-erp"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "database_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}
