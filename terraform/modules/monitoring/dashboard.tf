resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      # EKS Cluster Metrics
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 6
        height = 6
        properties = {
          metrics = [
            ["AWS/EKS", "CPUUtilization", "ClusterName", var.eks_cluster_name],
            [".", "MemoryUtilization", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "EKS Cluster - CPU & Memory"
          view   = "timeSeries"
        }
      },
      # Application Metrics
      {
        type   = "metric"
        x      = 6
        y      = 0
        width  = 6
        height = 6
        properties = {
          metrics = [
            ["ContainerInsights", "pod_number_of_running_containers", "ClusterName", var.eks_cluster_name, "Namespace", "default"],
            [".", "pod_cpu_usage_total", ".", ".", ".", "."],
            [".", "pod_memory_working_set", ".", ".", ".", "."]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Hello-World App - Pod Metrics"
        }
      },
      # RDS Metrics (only if RDS instance ID is provided)
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 6
        height = 6
        properties = {
          metrics = var.rds_instance_id != "" ? [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.rds_instance_id],
            [".", "DatabaseConnections", ".", "."],
            [".", "FreeStorageSpace", ".", "."]
            ] : [
            ["AWS/RDS", "CPUUtilization"]
          ]
          view   = "timeSeries"
          region = var.region
          title  = var.rds_instance_id != "" ? "RDS PostgreSQL - Performance" : "RDS - No Instance"
        }
      },
      # ElastiCache Metrics (only if Redis cluster ID is provided)
      {
        type   = "metric"
        x      = 6
        y      = 6
        width  = 6
        height = 6
        properties = {
          metrics = var.redis_cluster_id != "" ? [
            ["AWS/ElastiCache", "CPUUtilization", "CacheClusterId", var.redis_cluster_id],
            [".", "CurrConnections", ".", "."],
            [".", "CacheHits", ".", "."],
            [".", "CacheMisses", ".", "."]
            ] : [
            ["AWS/ElastiCache", "CPUUtilization"]
          ]
          view   = "timeSeries"
          region = var.region
          title  = var.redis_cluster_id != "" ? "ElastiCache Redis - Performance" : "Redis - No Cluster"
        }
      }
    ]
  })

}
