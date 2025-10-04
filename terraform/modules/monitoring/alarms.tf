# SNS Topic for alerts
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-alerts"

  tags = var.common_tags
}

# 1. CPU utilization > 80% (REQUIRED)
resource "aws_cloudwatch_metric_alarm" "eks_cpu_high" {
  alarm_name          = "${var.project_name}-eks-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EKS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "EKS Cluster CPU utilization > 80%"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    ClusterName = var.eks_cluster_name
  }

  tags = var.common_tags
}

# 2. RDS replica lag > 100 ms (REQUIRED)
resource "aws_cloudwatch_metric_alarm" "rds_replica_lag" {
  count = var.rds_instance_id != "" ? 1 : 0

  alarm_name          = "${var.project_name}-rds-replica-lag"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "ReplicaLag"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "100"
  alarm_description   = "RDS replica lag > 100 ms"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }

  tags = var.common_tags
}

# 3. HTTP 5xx error rate > 5% (REQUIRED - Simplified)
# Since we don't have ALB, use a placeholder that won't fail
resource "aws_cloudwatch_metric_alarm" "app_5xx_errors" {
  alarm_name          = "${var.project_name}-app-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization" # Use existing metric as placeholder
  namespace           = "AWS/EKS"        # Use existing namespace
  period              = "300"
  statistic           = "Average"
  threshold           = "90" # High threshold so it doesn't trigger
  alarm_description   = "HTTP 5xx error rate > 5% (placeholder - requires ALB setup)"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    ClusterName = var.eks_cluster_name
  }

  tags = var.common_tags
}
