# CloudWatch Log Group for application logs
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/eks/${var.eks_cluster_name}/hello-world"
  retention_in_days = 30
  # kms_key_id        = var.kms_key_arn

  tags = var.common_tags
}

# Log Group for infrastructure logs
resource "aws_cloudwatch_log_group" "infra_logs" {
  name              = "/aws/eks/${var.eks_cluster_name}/cluster"
  retention_in_days = 30
  # kms_key_id        = var.kms_key_arn

  tags = var.common_tags
}

# Subscription Filter for PII filtering
resource "aws_cloudwatch_log_subscription_filter" "pii_filter" {
  name            = "${var.project_name}-pii-filter"
  log_group_name  = aws_cloudwatch_log_group.app_logs.name
  filter_pattern  = ""  # Process all logs
  destination_arn = var.pii_lambda_arn

  depends_on = [aws_cloudwatch_log_group.app_logs]
}
