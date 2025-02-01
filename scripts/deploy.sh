#!/bin/bash

source ./env_setup.sh  # Import variables

#Step 1: Set Up Environment Variables
VPC_CIDR="10.59.0.0/16"
PUBLIC_SUBNET_CIDR="10.59.0.0/18"
PRIVATE_SUBNET_CIDR="10.59.64.0/18"
REGION="us-east-1"
AZ="us-east-1a"
VPC_NAME="my-vpc-$REGION"
PUBLIC_SUBNET_NAME="$VPC_NAME-public-subnet-1-$REGION"
PRIVATE_SUBNET_NAME="$VPC_NAME-private-subnet-1-$REGION"

#Step 2: Create the VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --region $REGION --query 'Vpc.VpcId' --output text)
echo "VPC ID: $VPC_ID"

aws ec2 create-tags --resources "$VPC_ID" --tags Key=Name,Value=$VPC_NAME --region $REGION

# Enable DNS support and hostname
aws ec2 modify-vpc-attribute --vpc-id "$VPC_ID" --enable-dns-support "{\"Value\":true}"
aws ec2 modify-vpc-attribute --vpc-id "$VPC_ID" --enable-dns-hostnames "{\"Value\":true}"

#Step 3: Create Subnets
#Public Subnet
PUBLIC_SUBNET_ID=$(aws ec2 create-subnet --vpc-id "$VPC_ID" --cidr-block $PUBLIC_SUBNET_CIDR --availability-zone $AZ --query 'Subnet.SubnetId' --output text)
echo "Public Subnet ID: $PUBLIC_SUBNET_ID"

aws ec2 create-tags --resources "$PUBLIC_SUBNET_ID" --tags Key=Name,Value=$PUBLIC_SUBNET_NAME --region $REGION

# Enable auto-assign public IP for public subnet
aws ec2 modify-subnet-attribute --subnet-id "$PUBLIC_SUBNET_ID" --map-public-ip-on-launch

#Private Subnet
PRIVATE_SUBNET_ID=$(aws ec2 create-subnet --vpc-id "$VPC_ID" --cidr-block $PRIVATE_SUBNET_CIDR --availability-zone $AZ --query 'Subnet.SubnetId' --output text)
echo "Private Subnet ID: $PRIVATE_SUBNET_ID"

aws ec2 create-tags --resources "$PRIVATE_SUBNET_ID" --tags Key=Name,Value=$PRIVATE_SUBNET_NAME --region $REGION
