#!/bin/bash

source ./env_setup.sh  # Import variables


#!/bin/bash
# Get all AWS regions
regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

# Loop through each region and check for NAT Gateways
for region in $regions; do
    echo "Checking NAT Gateways in region: $region"
    aws ec2 describe-nat-gateways --region "$region" --query "NatGateways[*].{ID:NatGatewayId, State:State}" --output table
    echo "--------------------------------------"
done
