resource "aws_iam_role" "karpenter_node_role" {
  name = "KarpenterNodeRole-${aws_eks_cluster.eks_cluster.name}"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "karpenter-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.karpenter_node_role.name
}

resource "aws_iam_role_policy_attachment" "karpenter-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.karpenter_node_role.name
}

resource "aws_iam_role_policy_attachment" "karpenter-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.karpenter_node_role.name
}

variable "karpenter_namespace" {
  default = "karpenter"
}

resource "aws_iam_role" "karpenter_controller" {
  name = "KarpenterControllerRole-${aws_eks_cluster.eks_cluster.name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.oidc_provider.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.aws_iam_oidc_connect_provider_extract_from_arn}:aud" = "sts.amazonaws.com"
            "${local.aws_iam_oidc_connect_provider_extract_from_arn}:sub" = "system:serviceaccount:${var.karpenter_namespace}:karpenter"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "karpenter_controller_policy" {
  name        = "KarpenterControllerPolicy-${aws_eks_cluster.eks_cluster.name}"
  description = "IAM policy for Karpenter Controller"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ec2:DescribeImages",
          "ec2:RunInstances",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DeleteLaunchTemplate",
          "ec2:CreateTags",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:DescribeSpotPriceHistory",
          "pricing:GetProducts"
        ]
        Resource = "*"
        Sid      = "Karpenter"
      },
      {
        Effect   = "Allow"
        Action   = "ec2:TerminateInstances"
        Resource = "*"
        Condition = {
          StringLike = {
            "ec2:ResourceTag/karpenter.sh/nodepool" = "*"
          }
        }
        Sid = "ConditionalEC2Termination"
      },
      {
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/KarpenterNodeRole-${aws_eks_cluster.eks_cluster.name}"
        Sid      = "PassNodeIAMRole"
      },
      {
        Effect   = "Allow"
        Action   = "eks:DescribeCluster"
        Resource = "arn:${data.aws_partition.current.partition}:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${aws_eks_cluster.eks_cluster.name}"
        Sid      = "EKSClusterEndpointLookup"
      },
      {
        Sid      = "AllowScopedInstanceProfileCreationActions"
        Effect   = "Allow"
        Resource = "*"
        Action   = ["iam:CreateInstanceProfile"]
        Condition = {
          StringEquals = {
            "aws:RequestTag/kubernetes.io/cluster/${aws_eks_cluster.eks_cluster.name}" = "owned"
            "aws:RequestTag/topology.kubernetes.io/region"                             = var.aws_region
          }
          StringLike = {
            "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass" = "*"
          }
        }
      },
      {
        Sid      = "AllowScopedInstanceProfileTagActions"
        Effect   = "Allow"
        Resource = "*"
        Action   = ["iam:TagInstanceProfile"]
        Condition = {
          StringEquals = {
            "aws:ResourceTag/kubernetes.io/cluster/${aws_eks_cluster.eks_cluster.name}" = "owned"
            "aws:ResourceTag/topology.kubernetes.io/region"                             = var.aws_region
            "aws:RequestTag/kubernetes.io/cluster/${aws_eks_cluster.eks_cluster.name}"  = "owned"
            "aws:RequestTag/topology.kubernetes.io/region"                              = var.aws_region
          }
          StringLike = {
            "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*"
            "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"  = "*"
          }
        }
      },
      {
        Sid      = "AllowScopedInstanceProfileActions"
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:DeleteInstanceProfile"
        ]
        Condition = {
          StringEquals = {
            "aws:ResourceTag/kubernetes.io/cluster/${aws_eks_cluster.eks_cluster.name}" = "owned"
            "aws:ResourceTag/topology.kubernetes.io/region"                             = var.aws_region
          }
          StringLike = {
            "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*"
          }
        }
      },
      {
        Sid      = "AllowInstanceProfileReadActions"
        Effect   = "Allow"
        Resource = "*"
        Action   = "iam:GetInstanceProfile"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "karpenter_controller_attach" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = aws_iam_policy.karpenter_controller_policy.arn
}
