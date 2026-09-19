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
  description = "Owner of the infrastructure"
  type        = string
  default     = "Rahul"
}

# ---------------------------------------------------------
# EKS
# ---------------------------------------------------------

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "microservices-demo-eks"
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.35"
}

variable "node_instance_types" {
  description = "EC2 instance types for EKS worker nodes"
  type        = list(string)

  default = [
    "m7i-flex.large"
  ]
}

variable "node_desired_size" {
  description = "Desired number of EKS worker nodes"
  type        = number
  default     = 4
}

variable "node_min_size" {
  description = "Minimum number of EKS worker nodes"
  type        = number
  default     = 3
}

variable "node_max_size" {
  description = "Maximum number of EKS worker nodes"
  type        = number
  default     = 10
}

# ---------------------------------------------------------
# ECR
# ---------------------------------------------------------

variable "ecr_repositories" {
  description = "ECR repositories for microservices-demo"
  type        = list(string)

  default = [
    "microservices-demo/adservice",
    "microservices-demo/cartservice",
    "microservices-demo/checkoutservice",
    "microservices-demo/currencyservice",
    "microservices-demo/emailservice",
    "microservices-demo/frontend",
    "microservices-demo/loadgenerator",
    "microservices-demo/paymentservice",
    "microservices-demo/productcatalogservice",
    "microservices-demo/recommendationservice",
    "microservices-demo/shippingservice",
    "microservices-demo/shoppingassistantservice",
  ]
}