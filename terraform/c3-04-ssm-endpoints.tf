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