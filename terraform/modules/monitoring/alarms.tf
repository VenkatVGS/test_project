# SNS Topic for alerts
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-alerts"

  tags = var.common_tags
}

# EKS CPU High Alarm
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

# EKS Node CPU High Alarm
resource "aws_cloudwatch_metric_alarm" "eks_node_cpu_high" {
  alarm_name          = "${var.project_name}-eks-node-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "node_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Average"
  threshold           = "85"
  alarm_description   = "EKS Node CPU utilization > 85%"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    ClusterName = var.eks_cluster_name
  }

  tags = var.common_tags
}

# RDS CPU High Alarm (if RDS exists)
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  count = var.rds_instance_id != "" ? 1 : 0

  alarm_name          = "${var.project_name}-rds-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "RDS CPU utilization > 80%"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }

  tags = var.common_tags
}

# RDS Storage Free Space Alarm (if RDS exists)
resource "aws_cloudwatch_metric_alarm" "rds_storage_low" {
  count = var.rds_instance_id != "" ? 1 : 0

  alarm_name          = "${var.project_name}-rds-storage-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "10737418240" # 10GB in bytes
  alarm_description   = "RDS free storage space < 10GB"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }

  tags = var.common_tags
}

# Application Error Rate Alarm (custom metric - we'll implement this later)
resource "aws_cloudwatch_metric_alarm" "app_5xx_errors" {
  alarm_name          = "${var.project_name}-app-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "5xxErrorCount"
  namespace           = "HelloWorldApp"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "Application 5xx errors > 10 in 5 minutes"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  tags = var.common_tags
}
