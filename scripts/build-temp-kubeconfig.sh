#!/bin/bash

echo "building a temp kubeconfig..."

source ./env_setup.sh

apiServerEndpoint=$(aws eks describe-cluster --name "car-dev-eksdemo" --query "cluster.endpoint" --output text)
echo "apiServerEndpoint: $apiServerEndpoint"

clusterCertificateAuthority=$(aws eks describe-cluster --name "car-dev-eksdemo" --query "cluster.certificateAuthority.data" --output text)
echo "clusterCertificateAuthority: $clusterCertificateAuthority"

kubeconfigTemplate="my-kubeconfig"
cp ../eks/"$kubeconfigTemplate" ../tmp/"kubeconfig"

yq e ".clusters[0].cluster.certificate-authority-data=\"${clusterCertificateAuthority}\"" -i ../tmp/"kubeconfig"
yq e ".clusters[0].cluster.server=\"${apiServerEndpoint}\"" -i ../tmp/"kubeconfig"

cat ../tmp/"kubeconfig"

export KUBECONFIG=../tmp/"kubeconfig"