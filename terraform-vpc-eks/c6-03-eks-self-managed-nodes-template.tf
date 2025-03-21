resource "aws_iam_instance_profile" "node_instance_profile" {
  name = "node-instance-profile"
  path = "/"
  role = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_launch_template" "node_launch_template" {
  name = "node-launch-template"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
      volume_size           = 20
      volume_type           = "gp2"
    }
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.node_instance_profile.arn
  }

  image_id = var.self_managed_image_id

  instance_type = var.self_managed_instance_type
  key_name      = var.self_managed_key_name

  vpc_security_group_ids = [aws_security_group.node_security_group.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh ${aws_eks_cluster.eks_cluster.name}
    /opt/aws/bin/cfn-signal --exit-code $? \
             --resource NodeGroup  \
             --region ${var.aws_region}
  EOF
  )

  metadata_options {
    http_put_response_hop_limit = 2
    http_endpoint               = "enabled"
    http_tokens                 = var.self_managed_disable_imdsv1 ? "required" : "optional"
  }
}
