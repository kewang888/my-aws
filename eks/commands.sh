kubectl version --client

aws eks update-kubeconfig --region eu-west-1 --name my-cluster

export KUBECONFIG=/Users/kwang04/my-projects/my-aws/eks/my-kubeconfig

#Added new context arn:aws:eks:eu-west-1:069057294951:cluster/my-cluster to /Users/kwang04/my-projects/my-aws/eks/my-kubeconfig
aws eks update-kubeconfig --region eu-west-1 --name my-cluster

kubectl get configmap aws-auth -n kube-system -o yaml

aws eks update-cluster-config --region eu-west-1 --name my-cluster \
  --resources-vpc-config endpointPublicAccess=false,endpointPrivateAccess=true

aws eks create-cluster --region eu-west-1 --name my-cluster --kubernetes-version 1.30 \
   --role-arn arn:aws:iam::069057294951:role/myAmazonEKSClusterRole \
   --resources-vpc-config subnetIds=subnet-0034f3632269ba9a7,subnet-0fd57081948009e97

aws ssm start-session --target <bastion_instance_id> --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{"portNumber":["443"],"localPortNumber":["42190"],"host":["api_server_endpoint_without_https"]}'
