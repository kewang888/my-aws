# Create AWS EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${local.name}-eksdemo"
  role_arn = aws_iam_role.eks_master_role.arn
  version  = var.cluster_version

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }


  vpc_config {
    subnet_ids              = module.vpc.public_subnets
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  # Enable EKS Cluster Control Plane Logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
  ]
}

resource "awscc_eks_access_entry" "node_group_entry" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = aws_iam_role.eks_nodegroup_role.arn
  type          = "STANDARD"
  username      = "${aws_iam_role.eks_nodegroup_role.arn}/{{SessionName}}"
  access_policies = [
    {
      access_scope = {
        type = "cluster"
      },
      policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
    }
  ]

  tags = [{
    key   = "Modified By"
    value = "AWSCC"
  }]
}

variable "iam_username" {
  description = "IAM user name"
  type        = string
  sensitive   = true # This prevents the username from being displayed in logs
}

data "aws_iam_user" "existing_user" {
  user_name = var.iam_username
}

resource "awscc_eks_access_entry" "iam_username_entry" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = data.aws_iam_user.existing_user.arn
  type          = "STANDARD"
  username      = "${data.aws_iam_user.existing_user.arn}/{{SessionName}}"
  access_policies = [
    {
      access_scope = {
        type = "cluster"
      },
      policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
    }
  ]

  tags = [{
    key   = "Modified By"
    value = "AWSCC"
  }]
}