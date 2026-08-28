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
# OIDC PROVIDER INFORMATION
# =========================================================

data "tls_certificate" "eks_oidc" {
  url = data.aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {

  url = data.aws_eks_cluster.main.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint
  ]
}

locals {

  oidc_issuer = replace(
    data.aws_eks_cluster.main.identity[0].oidc[0].issuer,
    "https://",
    ""
  )

  jenkins_role_name = "${var.cluster_name}-jenkins-role"
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