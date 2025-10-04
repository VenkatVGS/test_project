variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "log_group_arn" {
  description = "ARN of the CloudWatch Log Group to filter"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
