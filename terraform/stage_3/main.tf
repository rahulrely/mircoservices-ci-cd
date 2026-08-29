# =========================================================
# STAGE 2 REMOTE STATE
# =========================================================

data "terraform_remote_state" "stage_2" {
  backend = "s3"

  config = {
    bucket = "microservices-ci-cd-terraform-state1410"
    key    = "stage-2/terraform.tfstate"
    region = "ap-south-1"
  }
}


# =========================================================
# EKS CLUSTER INFORMATION
# =========================================================

data "aws_eks_cluster" "main" {
  name = data.terraform_remote_state.stage_2.outputs.eks_cluster_name
}


# =========================================================
# OIDC CERTIFICATE
# =========================================================

data "tls_certificate" "eks_oidc" {
  url = data.aws_eks_cluster.main.identity[0].oidc[0].issuer
}


# =========================================================
# EKS OIDC PROVIDER
# =========================================================

resource "aws_iam_openid_connect_provider" "eks" {

  url = data.aws_eks_cluster.main.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint
  ]
}


# =========================================================
# LOCALS
# =========================================================

locals {

  oidc_issuer = replace(
    data.aws_eks_cluster.main.identity[0].oidc[0].issuer,
    "https://",
    ""
  )

  jenkins_role_name = "${var.cluster_name}-jenkins-role"

  ebs_csi_role_name = "${var.cluster_name}-ebs-csi-role"
}


# =========================================================
# EBS CSI IAM POLICY
# =========================================================

data "aws_iam_policy" "ebs_csi" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}


# =========================================================
# EBS CSI IAM ROLE
# =========================================================

resource "aws_iam_role" "ebs_csi" {

  name = local.ebs_csi_role_name

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {

          StringEquals = {

            "${local.oidc_issuer}:aud" = "sts.amazonaws.com"

            "${local.oidc_issuer}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })

  tags = {
    Project     = "microservices-demo"
    Environment = "dev"
    ManagedBy   = "Terraform"
    Stage       = "stage-3"
  }
}


# =========================================================
# ATTACH EBS CSI POLICY
# =========================================================

resource "aws_iam_role_policy_attachment" "ebs_csi" {

  role = aws_iam_role.ebs_csi.name

  policy_arn = data.aws_iam_policy.ebs_csi.arn
}


# =========================================================
# JENKINS NAMESPACE
# =========================================================

resource "kubernetes_namespace" "jenkins" {

  metadata {

    name = var.jenkins_namespace

    labels = {
      app     = "jenkins"
      project = var.project_name
    }
  }
}


# =========================================================
# JENKINS IAM ROLE
# =========================================================

resource "aws_iam_role" "jenkins" {

  name = local.jenkins_role_name

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {

          StringEquals = {

            "${local.oidc_issuer}:aud" = "sts.amazonaws.com"

            "${local.oidc_issuer}:sub" = "system:serviceaccount:${var.jenkins_namespace}:${var.jenkins_service_account}"
          }
        }
      }
    ]
  })

  tags = {
    Project     = "microservices-demo"
    Environment = "dev"
    ManagedBy   = "Terraform"
    Stage       = "stage-3"
  }
}


# =========================================================
# JENKINS SERVICE ACCOUNT
# =========================================================

resource "kubernetes_service_account" "jenkins" {

  metadata {

    name      = var.jenkins_service_account
    namespace = kubernetes_namespace.jenkins.metadata[0].name

    annotations = {

      "eks.amazonaws.com/role-arn" = aws_iam_role.jenkins.arn
    }

    labels = {
      app = "jenkins"
    }
  }
}


# =========================================================
# EBS CSI EKS ADD-ON
# =========================================================

resource "aws_eks_addon" "ebs_csi" {

  cluster_name = data.terraform_remote_state.stage_2.outputs.eks_cluster_name

  addon_name = "aws-ebs-csi-driver"

  service_account_role_arn = aws_iam_role.ebs_csi.arn

  resolve_conflicts_on_create = "OVERWRITE"

  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_iam_role_policy_attachment.ebs_csi
  ]
}
