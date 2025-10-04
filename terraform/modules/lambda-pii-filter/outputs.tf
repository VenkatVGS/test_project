output "lambda_function_arn" {
  description = "ARN of the PII filtering Lambda function"
  value       = aws_lambda_function.pii_filter.arn
}

output "lambda_function_name" {
  description = "Name of the PII filtering Lambda function"
  value       = aws_lambda_function.pii_filter.function_name
}
