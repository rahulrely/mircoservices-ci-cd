variable "aws_region" {
  description = "AWS region where bootstrap resources will be created"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "microservices-demo"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "bootstrap"
}

variable "terraform_state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state"
  type        = string
}

variable "terraform_lock_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
  default     = "microservices-ci-cd-terraform-lock"
}

