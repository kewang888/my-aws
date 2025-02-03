# Create VPC Terraform Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"

  # VPC Basic Details
  name            = "${local.name}-${var.aws_region}"
  cidr            = var.vpc_cidr_block
  azs             = var.vpc_availability_zones
  public_subnets  = var.vpc_public_subnets
  private_subnets = var.vpc_private_subnets


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
  # $0.048 per hour in eu-west-1
  single_nat_gateway = var.vpc_single_nat_gateway
}

# # Apply unique Name tags to public subnets separately
# resource "aws_ec2_tag" "public_subnet_tags" {
#   for_each    = { for idx, subnet in module.vpc.public_subnets : idx => subnet }
#   resource_id = each.value
#   key         = "Name"
#   value       = "${local.name}-${var.aws_region}-public-subnet-${each.key + 1}"
# }
#
# resource "aws_ec2_tag" "private_subnet_tags" {
#   for_each    = { for idx, subnet in module.vpc.private_subnets : idx => subnet }
#   resource_id = each.value
#   key         = "Name"
#   value       = "${local.name}-${var.aws_region}-private-subnet-${each.key + 1}"
# }