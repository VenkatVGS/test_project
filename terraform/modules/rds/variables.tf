variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "allowed_security_groups" {
  description = "List of security group IDs allowed to access RDS"
  type        = list(string)
}

variable "database_username" {
  description = "Database master username"
  type        = string
  default     = "idurar_admin"
}

variable "database_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "kms_key_arn" {
  description = "KMS key ARN for encryption"
  type        = string
}
