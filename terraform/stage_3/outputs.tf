output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = data.terraform_remote_state.stage_2.outputs.eks_cluster_name
}


output "jenkins_namespace" {
  description = "Jenkins Kubernetes namespace"
  value       = kubernetes_namespace.jenkins.metadata[0].name
}


output "jenkins_service_account" {
  description = "Jenkins Kubernetes service account"
  value       = kubernetes_service_account.jenkins.metadata[0].name
}


output "jenkins_iam_role_arn" {
  description = "Jenkins IAM role ARN"
  value       = aws_iam_role.jenkins.arn
}


output "ebs_csi_iam_role_arn" {
  description = "EBS CSI IAM role ARN"
  value       = aws_iam_role.ebs_csi.arn
}


output "ebs_csi_addon_name" {
  description = "EBS CSI EKS add-on"
  value       = aws_eks_addon.ebs_csi.addon_name
}