# KMS Key for RDS Encryption
resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name    = "${var.project_name}-rds-kms"
    Purpose = "RDS Encryption"
  }
}

# KMS Key for EBS Encryption
resource "aws_kms_key" "ebs" {
  description             = "KMS key for EBS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name    = "${var.project_name}-ebs-kms"
    Purpose = "EBS Encryption"
  }
}

# KMS Key for S3 Encryption
resource "aws_kms_key" "s3" {
  description             = "KMS key for S3 encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name    = "${var.project_name}-s3-kms"
    Purpose = "S3 Encryption"
  }
}
