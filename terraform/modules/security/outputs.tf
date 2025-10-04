output "guardduty_detector_id" {
  description = "GuardDuty detector ID"
  value       = aws_guardduty_detector.main.id
}

output "config_rules_created" {
  description = "List of AWS Config rules created"
  value = [
    aws_config_config_rule.restricted_ssh.name,
    aws_config_config_rule.s3_bucket_encryption.name,
    aws_config_config_rule.rds_encryption.name
  ]
}

# SSM outputs
output "ssm_kms_key_id" {
  description = "KMS Key ID for SSM encryption"
  value       = aws_kms_key.ssm_key.key_id
}

output "ssm_db_password_arn" {
  description = "ARN of DB password in SSM"
  value       = aws_ssm_parameter.db_password.arn
  sensitive   = true
}

output "ssm_app_secret_arn" {
  description = "ARN of app secret in SSM"
  value       = aws_ssm_parameter.app_secret.arn
  sensitive   = true
}

# Add these outputs to security module
output "generated_db_password" {
  description = "The generated database password"
  value       = random_password.db_password.result
  sensitive   = true
}

output "generated_app_secret" {
  description = "The generated application secret"
  value       = random_password.app_secret.result
  sensitive   = true
}
