#!/bin/bash

source ./env_setup.sh  # Import variables

#Step 1: Set Up Environment Variables
VPC_CIDR="10.59.0.0/16"
PUBLIC_SUBNET_CIDR="10.59.0.0/18"
PRIVATE_SUBNET_CIDR="10.59.64.0/18"
REGION="us-east-1"
AZ="us-east-1a"
VPC_NAME="my-vpc"

#Step 2: Create the VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --region $REGION --query 'Vpc.VpcId' --output text)
echo "VPC ID: $VPC_ID"

aws ec2 create-tags --resources "$VPC_ID" --tags Key=Name,Value=$VPC_NAME-$REGION --region $REGION

# Enable DNS support and hostname
aws ec2 modify-vpc-attribute --vpc-id "$VPC_ID" --enable-dns-support "{\"Value\":true}"
aws ec2 modify-vpc-attribute --vpc-id "$VPC_ID" --enable-dns-hostnames "{\"Value\":true}"

