variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "microservices-demo"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Infrastructure owner"
  type        = string
  default     = "Rahul"
}

variable "cluster_name" {
  description = "Existing EKS cluster"
  type        = string
  default     = "microservices-demo-eks"
}

variable "jenkins_namespace" {
  description = "Kubernetes namespace for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "jenkins_service_account" {
  description = "Jenkins Kubernetes service account"
  type        = string
  default     = "jenkins"
}