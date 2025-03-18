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