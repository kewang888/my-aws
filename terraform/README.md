<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.9.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.68.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.68.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.18.1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.private_ec_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.private_ec2_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.ssm_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.private_ec2_role](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.s3_attach_policy](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.private_instance](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/instance) | resource |
| [aws_lb.web_alb](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/lb) | resource |
| [aws_lb_listener.http_listener](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.tg](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.tg_attach](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/lb_target_group_attachment) | resource |
| [aws_s3_bucket.demo_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_object.example](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/s3_object) | resource |
| [aws_security_group.alb_sg](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/security_group) | resource |
| [aws_security_group.private_ec2_sg](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/security_group) | resource |
| [aws_security_group.vpce_sg](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/security_group) | resource |
| [aws_vpc_endpoint.ec2_messages](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3_endpoint](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ssm](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ssm_messages](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/resources/vpc_endpoint) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.68.0/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region in which AWS Resources to be created | `string` | `"eu-west-1"` | no |
| <a name="input_business_division"></a> [business\_division](#input\_business\_division) | Business Division in the large organization this Infrastructure belongs | `string` | `"car"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment Variable used as a prefix | `string` | `"dev"` | no |
| <a name="input_vpc_availability_zones"></a> [vpc\_availability\_zones](#input\_vpc\_availability\_zones) | VPC Availability Zones | `list(string)` | <pre>[<br/>  "eu-west-1a",<br/>  "eu-west-1c"<br/>]</pre> | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | VPC CIDR Block | `string` | `"10.59.0.0/16"` | no |
| <a name="input_vpc_enable_nat_gateway"></a> [vpc\_enable\_nat\_gateway](#input\_vpc\_enable\_nat\_gateway) | Enable NAT Gateways for Private Subnets Outbound Communication | `bool` | `true` | no |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | VPC Private Subnets | `list(string)` | <pre>[<br/>  "10.59.128.0/18",<br/>  "10.59.192.0/18"<br/>]</pre> | no |
| <a name="input_vpc_public_subnets"></a> [vpc\_public\_subnets](#input\_vpc\_public\_subnets) | VPC Public Subnets | `list(string)` | <pre>[<br/>  "10.59.0.0/18",<br/>  "10.59.64.0/18"<br/>]</pre> | no |
| <a name="input_vpc_single_nat_gateway"></a> [vpc\_single\_nat\_gateway](#input\_vpc\_single\_nat\_gateway) | Enable only single NAT Gateway in one Availability Zone to save costs during our demos | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_account_id"></a> [aws\_account\_id](#output\_aws\_account\_id) | n/a |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->