variable "self_managed_node_group_name" {
  default = "my-node-group"
}

variable "self_managed_instance_type" {
  default = "t3.micro"
}

variable "self_managed_desired_capacity" {
  default = 4
}

variable "self_managed_min_size" {
  default = 1
}

variable "self_managed_max_size" {
  default = 8
}

variable "self_managed_key_name" {
  default = "eks-terraform-key"
}

variable "self_managed_disk_size" {
  default = 20
}

#aws ssm get-parameter --name /aws/service/eks/optimized-ami/1.30/amazon-linux-2/recommended/image_id --region us-east-1 --query "Parameter.Value" --output text
# ami used by the cloudformation is also: ami-0e4591ba595196441
variable "self_managed_image_id" {
  default = "ami-0e4591ba595196441"
}

variable "self_managed_bootstrap_arguments" {
  default = ""
}

variable "self_managed_disable_imdsv1" {
  default = false
}




