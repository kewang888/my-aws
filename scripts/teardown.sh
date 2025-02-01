#!/bin/bash

source ./env_setup.sh  # Import variables

#Step 1: Set Up Environment Variables
VPC_CIDR="10.59.0.0/16"
PUBLIC_SUBNET_CIDR="10.59.0.0/18"
PRIVATE_SUBNET_CIDR="10.59.64.0/18"
REGION="us-east-1"
AZ="us-east-1a"
VPC_NAME="my-vpc"

# Fetch VPC ID
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=cidr-block,Values=$VPC_CIDR" --query "Vpcs[0].VpcId" --output text)
echo "VPC ID: $VPC_ID"

if [[ "$VPC_ID" == "None" ]]; then
  echo "No VPC found. Exiting..."
  exit 1
fi

echo "Deleting VPC..."
aws ec2 delete-vpc --vpc-id "$VPC_ID"