# KMS Key for SSM
resource "aws_kms_key" "ssm_key" {
  description             = "KMS key for SSM Parameter Store encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "idurar-erp-ssm-key"
  }
}

# KMS Alias
resource "aws_kms_alias" "ssm_key" {
  name          = "alias/idurar-erp-ssm-key"
  target_key_id = aws_kms_key.ssm_key.key_id
}

# Generate random password for database
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Generate random secret for application
resource "random_password" "app_secret" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# SSM Parameters for application secrets
resource "aws_ssm_parameter" "db_password" {
  name        = "/idurar-erp/${var.environment}/DB_PASSWORD"
  description = "PostgreSQL database password"
  type        = "SecureString"
  value       = random_password.db_password.result
  key_id      = aws_kms_key.ssm_key.key_id

  tags = {
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "app_secret" {
  name        = "/idurar-erp/${var.environment}/APP_SECRET"
  description = "Application secret key"
  type        = "SecureString"
  value       = random_password.app_secret.result
  key_id      = aws_kms_key.ssm_key.key_id

  tags = {
    Environment = var.environment
  }
}

# Optional: Database connection string
#resource "aws_ssm_parameter" "db_url" {
#  name        = "/idurar-erp/${var.environment}/DB_URL"
#  description = "PostgreSQL database connection URL"
#  type        = "SecureString"
#  value       = "postgresql://${var.database_username}:${random_password.db_password.result}@${var.database_host}:5432/${var.database_name}"
#  key_id      = aws_kms_key.ssm_key.key_id
#
#  tags = {
#    Environment = var.environment
#  }
#}
