terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket         = "microservices-ci-cd-terraform-state1410"
    key            = "stage-2/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "microservices-ci-cd-terraform-lock"
    encrypt        = true
  }
}