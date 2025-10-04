# SNS Email Subscription for alerts
resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "venkat.tendulkar@gmail.com"
}
