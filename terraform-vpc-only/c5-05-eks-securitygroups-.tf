# Security Group for EKS Node Group - Placeholder file
resource "aws_security_group" "k8s_nodeport" {
  name        = "KubernetesNodePortSG"
  description = "Allow NodePort traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change this to restrict access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
