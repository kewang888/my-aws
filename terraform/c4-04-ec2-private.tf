resource "aws_instance" "private_instance" {
  ami                    = "ami-0c614dee691cbbf37" # Replace with a valid AMI ID
  instance_type          = "t3.micro"
  subnet_id              = module.vpc.private_subnets[0] # Dynamically get private subnet ID
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_instance_profile.name # Attach SSM role

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl enable httpd
              sudo systemctl start httpd
              EOF

  tags = {
    Name = "private-ec2-instance"
  }
}

# Security Group for this private EC2
resource "aws_security_group" "private_ec2_sg" {
  vpc_id = module.vpc.vpc_id

  # Allow all outbound traffic (needed for SSM communication)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role for EC2 (SSM Permissions)
# "This role can be used by EC2 instances to interact with other AWS services, such as Systems Manager."
resource "aws_iam_role" "ssm_role" {
  name = "EC2SSMRole"

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

# Attach necessary policies for SSM
resource "aws_iam_policy_attachment" "ssm_policy_attach" {
  name       = "ssm-attachment"
  roles      = [aws_iam_role.ssm_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

# **VPC Endpoints for SSM** (For Private Access)
resource "aws_vpc_endpoint" "ssm" {
  vpc_id             = module.vpc.vpc_id
  service_name       = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [module.vpc.private_subnets[0]]
  security_group_ids = [aws_security_group.private_ec2_sg.id]
}

resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id             = module.vpc.vpc_id
  service_name       = "com.amazonaws.us-east-1.ssmmessages"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [module.vpc.private_subnets[0]]
  security_group_ids = [aws_security_group.private_ec2_sg.id]
}

resource "aws_vpc_endpoint" "ec2_messages" {
  vpc_id             = module.vpc.vpc_id
  service_name       = "com.amazonaws.us-east-1.ec2messages"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [module.vpc.private_subnets[0]]
  security_group_ids = [aws_security_group.private_ec2_sg.id]
}