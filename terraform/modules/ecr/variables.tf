variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the KMS key for encryption"
  type        = string
  default     = null
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

#variable "allowed_principal_arns" {
#  description = "List of ARNs allowed to pull from ECR"
#  type        = list(string)
#  default     = []
#}
