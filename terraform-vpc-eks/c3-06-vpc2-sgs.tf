resource "aws_security_group" "allow_vpc2_internal" {
  name        = "allow-vpc2-internal"
  description = "Allow all traffic within the VPC"
  vpc_id      = module.vpc2.vpc_id

  ingress {
    description = "Allow all inbound traffic within the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc2.vpc_cidr_block]
  }

  egress {
    description = "Allow all outbound traffic within the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc2.vpc_cidr_block]
  }
}