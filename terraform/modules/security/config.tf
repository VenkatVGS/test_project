# AWS Config Rules Only (assume Config is already enabled in account)

# 1. Disallowed Security Group open to 0.0.0.0/0
resource "aws_config_config_rule" "restricted_ssh" {
  name = "${var.project_name}-restricted-ssh"

  source {
    owner             = "AWS"
    source_identifier = "RESTRICTED_INCOMING_TRAFFIC"
  }

  input_parameters = jsonencode({
    "blockedPort1" : "22",
    "blockedPort2" : "3389",
    "blockedPort3" : "21"
  })
}

# 2. Unencrypted S3 buckets
resource "aws_config_config_rule" "s3_bucket_encryption" {
  name = "${var.project_name}-s3-encryption"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  }
}

# 3. RDS instances without encryption
resource "aws_config_config_rule" "rds_encryption" {
  name = "${var.project_name}-rds-encryption"

  source {
    owner             = "AWS"
    source_identifier = "RDS_STORAGE_ENCRYPTED"
  }
}
