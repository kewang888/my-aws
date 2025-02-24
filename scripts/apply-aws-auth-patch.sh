#!/bin/sh

set -e

kubectl -n kube-system get configmap aws-auth -o yaml > ./aws-auth-base.yaml

#cp ../eks/aws-auth-cm-missing-nodegroup-role.yaml ./aws-auth-base.yaml

echo "the existing aws-auth configmap"
cat ./aws-auth-base.yaml

FILE="./aws-auth-base.yaml"
ROLE_ARN="arn:aws:iam::069057294951:role/car-dev-eks-nodegroup-role"

# Check if the role already exists in the YAML file
if yq eval ".data.mapRoles | contains(\"$ROLE_ARN\")" "$FILE" | grep -q "true"; then
  echo "Role already exists. No changes made."
else
  echo "Role not found. Appending to mapRoles..."
  yq eval '.data.mapRoles |= . + "- rolearn: '"$ROLE_ARN"'\n  username: system:node:{{EC2PrivateDNSName}}\n  groups:\n    - system:bootstrappers\n    - system:nodes\n"' -i "$FILE"

  echo "the modified aws-auth configmap"
  cat ./aws-auth-base.yaml
fi

kubectl apply --dry-run=client -f ./aws-auth-base.yaml

echo "about to apply the modified aws-auth configmap"
kubectl apply -f ./aws-auth-base.yaml


