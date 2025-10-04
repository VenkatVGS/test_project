# CloudWatch Log Group for application logs
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/eks/${var.eks_cluster_name}/hello-world"
  retention_in_days = 30
  kms_key_id        = var.kms_key_arn

  tags = var.common_tags
}

# Log Group for infrastructure logs
resource "aws_cloudwatch_log_group" "infra_logs" {
  name              = "/aws/eks/${var.eks_cluster_name}/cluster"
  retention_in_days = 30
  kms_key_id        = var.kms_key_arn

  tags = var.common_tags
}
