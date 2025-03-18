# Create VPC Terraform Module
module "vpc2" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"

  # VPC Basic Details
  name            = "${local.name}-2-${var.aws_region}"
  cidr            = "10.58.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.58.0.0/18", "10.58.64.0/18"]
  private_subnets = ["10.58.128.0/18", "10.58.192.0/18"]


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
  map_public_ip_on_launch = true

  # Should be true if you want to provision NAT Gateways for each of your private networks
  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = var.vpc_single_nat_gateway
}