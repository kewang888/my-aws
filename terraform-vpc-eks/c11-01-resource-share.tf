resource "aws_security_group" "my_resource_gateway_sg" {
  name   = "my_resource_gateway_sg"
  vpc_id = module.vpc2.vpc_id
}

resource "aws_security_group_rule" "my_resource_gateway_sg_egress" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.my_resource_gateway_sg.id
  source_security_group_id = aws_security_group.internal_alb2_sg.id
}

resource "aws_vpclattice_resource_gateway" "my_resource_gateway" {
  name               = "my-resource-gateway"
  vpc_id             = module.vpc2.vpc_id
  subnet_ids         = module.vpc2.private_subnets
  security_group_ids = [aws_security_group.my_resource_gateway_sg.id]
  ip_address_type    = "IPV4"

  tags = {
    Environment = "Example"
  }
}

resource "aws_vpclattice_resource_configuration" "my_resource_configuration" {
  name = "my-resource-configuration"

  resource_gateway_identifier = aws_vpclattice_resource_gateway.my_resource_gateway.id

  port_ranges = ["80"]
  protocol    = "TCP"

  resource_configuration_definition {
    dns_resource {
      domain_name     = aws_lb.internal_alb2.dns_name
      ip_address_type = "IPV4"
    }
  }

  tags = {
    Environment = "Example"
  }
}

resource "aws_security_group" "my_resource_endpoint_sg" {
  name   = "my_resource_endpoint_sg"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "my_resource_endpoint_sg_ingress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.my_resource_endpoint_sg.id
  source_security_group_id = aws_security_group.node_security_group.id
}

resource "aws_vpc_endpoint" "my_resource_endpoint" {
  resource_configuration_arn = aws_vpclattice_resource_configuration.my_resource_configuration.arn
  subnet_ids                 = module.vpc.private_subnets
  vpc_endpoint_type          = "Resource"
  vpc_id                     = module.vpc.vpc_id
  security_group_ids = [
    aws_security_group.my_resource_endpoint_sg.id,
  ]
}
