resource "aws_instance" "private_instance" {
  ami                    = "ami-05edf2d87fdbd91c1" # Replace with a valid AMI ID
  instance_type          = "t3.micro"
  subnet_id              = module.vpc.private_subnets[0] # Dynamically get private subnet ID
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.private_ec_instance_profile.name # Attach SSM role

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
  name   = "private-ec2-security-group"

  # Allow all outbound traffic (needed for SSM communication)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vpce_sg" {
  vpc_id = module.vpc.vpc_id
  name   = "vpce-security-group"

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.private_ec2_sg.id]
  }
}

# IAM Role for EC2
# "This role can be used by EC2 instances to interact with other AWS services, such as Systems Manager."
resource "aws_iam_role" "private_ec2_role" {
  name = "PrivateEC2Role"

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
  roles      = [aws_iam_role.private_ec2_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "private_ec_instance_profile" {
  name = "ssm-instance-profile"
  role = aws_iam_role.private_ec2_role.name
}

# **VPC Endpoints for SSM** (For Private Access)
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [module.vpc.private_subnets[0]]
  security_group_ids  = [aws_security_group.vpce_sg.id] # ✅ Use separate security group
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [module.vpc.private_subnets[0]]
  security_group_ids  = [aws_security_group.vpce_sg.id] # ✅ Use separate security group
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ec2_messages" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [module.vpc.private_subnets[0]]
  security_group_ids  = [aws_security_group.vpce_sg.id] # ✅ Use separate security group
  private_dns_enabled = true
}

resource "aws_iam_policy" "private_ec2_s3_policy" {
  name        = "ec2-s3-policy"
  description = "Policy allowing EC2 to access S3"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.demo_s3_bucket.arn}/*",
          aws_s3_bucket.demo_s3_bucket.arn
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "s3:ListAllMyBuckets",
        "Resource" : "arn:aws:s3:::*"
      }
    ]
  })
}

# Attach the IAM policy to the role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.private_ec2_role.name
  policy_arn = aws_iam_policy.private_ec2_s3_policy.arn
}