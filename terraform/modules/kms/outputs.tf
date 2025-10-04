
output "rds_kms_key_id" {
  description = "KMS key ID for RDS encryption"
  value       = aws_kms_key.rds.key_id
}

output "rds_kms_key_arn" {
  description = "KMS key ARN for RDS encryption"
  value       = aws_kms_key.rds.arn
}

output "ebs_kms_key_id" {
  description = "KMS key ID for EBS encryption"
  value       = aws_kms_key.ebs.key_id
}

output "ebs_kms_key_arn" {
  description = "KMS key ARN for EBS encryption"
  value       = aws_kms_key.ebs.arn
}

output "s3_kms_key_id" {
  description = "KMS key ID for S3 encryption"
  value       = aws_kms_key.s3.key_id
}

output "s3_kms_key_arn" {
  description = "KMS key ARN for S3 encryption"
  value       = aws_kms_key.s3.arn
}

