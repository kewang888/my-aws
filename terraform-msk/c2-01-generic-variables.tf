# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}
# Business Division
variable "business_division" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "car"
}

data "aws_caller_identity" "current" {}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

# The aws_partition data source returns:
#
# id → The partition name (aws, aws-cn, or aws-us-gov).
# dns_suffix → The DNS suffix for the partition (e.g., amazonaws.com, amazonaws.com.cn for China).
# partition → The partition name (same as id).
data "aws_partition" "current" {}