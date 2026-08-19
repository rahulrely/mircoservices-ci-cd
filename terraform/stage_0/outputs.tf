output "aws_region" {
  description = "AWS region used by the bootstrap"
  value       = var.aws_region
}

output "terraform_state_bucket_name" {
  description = "S3 bucket containing Terraform state"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "terraform_state_bucket_arn" {
  description = "ARN of Terraform state S3 bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

output "terraform_lock_table_name" {
  description = "DynamoDB table used for Terraform state locking"
  value       = aws_dynamodb_table.terraform_lock.name
}

output "terraform_lock_table_arn" {
  description = "ARN of DynamoDB Terraform lock table"
  value       = aws_dynamodb_table.terraform_lock.arn
}