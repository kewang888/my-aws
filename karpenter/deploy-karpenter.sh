#!/bin/bash

#set -e  # Enable exit on error and command tracing

PROJECT_ROOT=$(cd "$(dirname "$0")/.." && pwd)

source "$PROJECT_ROOT"/scripts/build-temp-kubeconfig.sh

KARPENTER_NAMESPACE="karpenter"
CLUSTER_NAME="car-dev-eksdemo"
AWS_PARTITION="aws"

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)

export KARPENTER_VERSION="1.2.1"

helm template karpenter oci://public.ecr.aws/karpenter/karpenter --version "${KARPENTER_VERSION}" --namespace "${KARPENTER_NAMESPACE}" \
    --set "settings.clusterName=${CLUSTER_NAME}" \
    --set "settings.interruptionQueue=${CLUSTER_NAME}" \
    --set "serviceAccount.annotations.eks\.amazonaws\.com/role-arn=arn:${AWS_PARTITION}:iam::${AWS_ACCOUNT_ID}:role/KarpenterControllerRole-${CLUSTER_NAME}" \
    --set controller.resources.requests.cpu=1 \
    --set controller.resources.requests.memory=1Gi \
    --set controller.resources.limits.cpu=1 \
    --set controller.resources.limits.memory=1Gi > karpenter.yaml

kubectl version --client
kubectl create namespace "${KARPENTER_NAMESPACE}" || true

kubectl create -f \
    "https://raw.githubusercontent.com/aws/karpenter-provider-aws/v${KARPENTER_VERSION}/pkg/apis/crds/karpenter.sh_nodepools.yaml"
kubectl create -f \
    "https://raw.githubusercontent.com/aws/karpenter-provider-aws/v${KARPENTER_VERSION}/pkg/apis/crds/karpenter.k8s.aws_ec2nodeclasses.yaml"
kubectl create -f \
    "https://raw.githubusercontent.com/aws/karpenter-provider-aws/v${KARPENTER_VERSION}/pkg/apis/crds/karpenter.sh_nodeclaims.yaml"
kubectl apply -f karpenter.yaml

