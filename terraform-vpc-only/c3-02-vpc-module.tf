# Create VPC Terraform Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"

  # VPC Basic Details
  name           = "${local.name}-${var.aws_region}"
  cidr           = var.vpc_cidr_block
  azs            = var.vpc_availability_zones
  public_subnets = var.vpc_public_subnets
  # private_subnets = var.vpc_private_subnets


  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags     = local.common_tags
  vpc_tags = local.common_tags

  public_subnet_tags = {

  }

  private_subnet_tags = {

  }

  # Instances launched into the Public subnet should be assigned a public IP address.
  map_public_ip_on_launch = false

  # Should be true if you want to provision NAT Gateways for each of your private networks
  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = var.vpc_single_nat_gateway
}