
variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "deletion_window_in_days" {
  description = "Days to wait before deletion"
  type        = number
  default     = 7
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
