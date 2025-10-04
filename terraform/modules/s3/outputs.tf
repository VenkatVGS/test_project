output "terraform_state_bucket" {
  description = "Terraform state S3 bucket name"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "static_assets_bucket" {
  description = "Static assets S3 bucket name"
  value       = aws_s3_bucket.static_assets.bucket
}
