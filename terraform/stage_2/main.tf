# =========================================================
# EKS CLUSTER IAM ROLE
# =========================================================

resource "aws_iam_role" "eks_cluster" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "eks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role = aws_iam_role.eks_cluster.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


# =========================================================
# EKS CLUSTER
# =========================================================

resource "aws_eks_cluster" "main" {

  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  version = var.kubernetes_version

  vpc_config {

    subnet_ids = var.private_subnet_ids

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}


# =========================================================
# NODE GROUP IAM ROLE
# =========================================================

resource "aws_iam_role" "eks_nodes" {

  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }

    ]
  })
}


resource "aws_iam_role_policy_attachment" "worker_node_policy" {

  role = aws_iam_role.eks_nodes.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}


resource "aws_iam_role_policy_attachment" "cni_policy" {

  role = aws_iam_role.eks_nodes.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


resource "aws_iam_role_policy_attachment" "ecr_read_only" {

  role = aws_iam_role.eks_nodes.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


# =========================================================
# EKS NODE GROUP
# =========================================================

resource "aws_eks_node_group" "main" {

  cluster_name = aws_eks_cluster.main.name

  node_group_name = "${var.cluster_name}-nodes"

  node_role_arn = aws_iam_role.eks_nodes.arn

  subnet_ids = var.private_subnet_ids

  instance_types = var.node_instance_types

  capacity_type = "ON_DEMAND"

  scaling_config {

    desired_size = var.node_desired_size

    min_size = var.node_min_size

    max_size = var.node_max_size
  }

  update_config {

    max_unavailable = 1
  }

  depends_on = [

    aws_iam_role_policy_attachment.worker_node_policy,

    aws_iam_role_policy_attachment.cni_policy,

    aws_iam_role_policy_attachment.ecr_read_only
  ]
}


# =========================================================
# EKS ADDONS
# =========================================================

resource "aws_eks_addon" "vpc_cni" {

  cluster_name = aws_eks_cluster.main.name

  addon_name = "vpc-cni"

  resolve_conflicts_on_create = "OVERWRITE"

  resolve_conflicts_on_update = "OVERWRITE"
}


resource "aws_eks_addon" "kube_proxy" {

  cluster_name = aws_eks_cluster.main.name

  addon_name = "kube-proxy"

  resolve_conflicts_on_create = "OVERWRITE"

  resolve_conflicts_on_update = "OVERWRITE"
}


resource "aws_eks_addon" "coredns" {

  cluster_name = aws_eks_cluster.main.name

  addon_name = "coredns"

  resolve_conflicts_on_create = "OVERWRITE"

  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_node_group.main
  ]
}


# =========================================================
# ECR REPOSITORIES
# =========================================================

resource "aws_ecr_repository" "microservices" {

  for_each = toset(var.ecr_repositories)

  name = each.value

  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {

    scan_on_push = true
  }

  encryption_configuration {

    encryption_type = "AES256"
  }
}


# =========================================================
# ECR LIFECYCLE POLICY
# =========================================================

resource "aws_ecr_lifecycle_policy" "microservices" {

  for_each = aws_ecr_repository.microservices

  repository = each.value.name

  policy = jsonencode({

    rules = [

      {
        rulePriority = 1

        description = "Keep last 20 images"

        selection = {

          tagStatus = "any"

          countType = "imageCountMoreThan"

          countNumber = 20
        }

        action = {

          type = "expire"
        }
      }

    ]
  })
}