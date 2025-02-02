# Create an S3 Gateway VPC Endpoint
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  # Attach it to the private route table
  route_table_ids = [module.vpc.private_route_table_ids[0]]
}