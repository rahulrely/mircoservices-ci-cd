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
