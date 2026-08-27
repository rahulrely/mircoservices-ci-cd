output "eks_cluster_name" {
  description = "Existing EKS cluster"
  value       = data.aws_eks_cluster.main.name
}

output "jenkins_namespace" {
  description = "Jenkins namespace"
  value       = kubernetes_namespace.jenkins.metadata[0].name
}

output "jenkins_service_account" {
  description = "Jenkins service account"
  value       = kubernetes_service_account.jenkins.metadata[0].name
}

output "jenkins_iam_role_arn" {
  description = "IAM role associated with Jenkins"
  value       = aws_iam_role.jenkins.arn
}