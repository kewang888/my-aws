resource "aws_autoscaling_group" "node_group" {

  name                = var.self_managed_node_group_name
  desired_capacity    = var.self_managed_desired_capacity
  max_size            = var.self_managed_max_size
  min_size            = var.self_managed_min_size
  vpc_zone_identifier = module.vpc.public_subnets

  launch_template {
    id      = aws_launch_template.node_launch_template.id
    version = aws_launch_template.node_launch_template.latest_version
  }

  # Rolling update configuration
  lifecycle {
    create_before_destroy = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = (var.self_managed_desired_capacity * 100) / var.self_managed_max_size
      instance_warmup        = 300
    }
  }

  tag {
    key                 = "Name"
    value               = "${aws_eks_cluster.eks_cluster.name}-${var.self_managed_node_group_name}-Node"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${aws_eks_cluster.eks_cluster.name}"
    value               = "owned"
    propagate_at_launch = true
  }
}


