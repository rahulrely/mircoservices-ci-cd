# =========================================================
# EKS
# =========================================================

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  description = "EKS API endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "eks_cluster_arn" {
  description = "EKS cluster ARN"
  value       = aws_eks_cluster.main.arn
}

output "eks_cluster_version" {
  description = "Kubernetes version"
  value       = aws_eks_cluster.main.version
}

output "eks_cluster_security_group_id" {
  description = "EKS cluster security group"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

# =========================================================
# NODE GROUP
# =========================================================

output "eks_node_group_name" {
  description = "EKS node group name"
  value       = aws_eks_node_group.main.node_group_name
}

output "eks_node_role_arn" {
  description = "EKS node IAM role ARN"
  value       = aws_iam_role.eks_nodes.arn
}

# =========================================================
# ECR
# =========================================================

output "ecr_repository_urls" {
  description = "ECR repository URLs"
  value = {
    for name, repo in aws_ecr_repository.microservices :
    name => repo.repository_url
  }
}

# =========================================================
# NETWORK
# =========================================================

output "vpc_id" {
  description = "VPC used by EKS"
  value       = var.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnets used by EKS"
  value       = var.private_subnet_ids
}