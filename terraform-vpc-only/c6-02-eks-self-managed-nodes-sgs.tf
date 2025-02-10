resource "aws_security_group" "node_security_group" {
  name        = "node-security-group"
  description = "Security group for all nodes in the cluster"
  vpc_id      = module.vpc.vpc_id

  tags = {
    "kubernetes.io/cluster/${aws_eks_cluster.eks_cluster.name}" = "owned"
  }
}

resource "aws_security_group_rule" "node_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.node_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow nodes to communicate with the internet"
}

resource "aws_security_group_rule" "node_security_group_ingress" {
  description              = "Allow node to communicate with each other"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.node_security_group.id
  source_security_group_id = aws_security_group.node_security_group.id
}

resource "aws_security_group_rule" "node_sg_from_control_plane_ingress" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.node_security_group.id
  source_security_group_id = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "control_plane_egress_to_node_sg" {
  description              = "Allow the cluster control plane to communicate with worker Kubelet and pods"
  type                     = "egress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
  source_security_group_id = aws_security_group.node_security_group.id
}

resource "aws_security_group_rule" "cluster_control_plane_sg_ingress" {
  description              = "Allow pods to communicate with the cluster API Server"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
  source_security_group_id = aws_security_group.node_security_group.id
}

resource "aws_security_group_rule" "control_plane_egress_to_node_sg_443" {
  description              = "Allow the cluster control plane to communicate with pods running extension API servers on port 443"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
  source_security_group_id = aws_security_group.node_security_group.id
}

resource "aws_security_group_rule" "node_sg_from_control_plane_on_443_ingress" {
  description              = "Allow pods running extension API servers on port 443 to receive communication from cluster control plane"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.node_security_group.id
  source_security_group_id = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}