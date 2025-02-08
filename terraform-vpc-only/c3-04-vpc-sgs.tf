resource "aws_security_group" "allow_vpc_internal" {
  name        = "allow-vpc-internal"
  description = "Allow all traffic within the VPC"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow all inbound traffic within the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    description = "Allow all outbound traffic within the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
}