#Using AWS CLI to Get Amazon Linux 2 AMI with SSM Agent
aws ssm get-parameters-by-path --path "/aws/service/ami-amazon-linux-latest" --query "Parameters[*].{Name:Name,Value:Value}"

aws ssm start-session --target i-002dc5db373054e04

aws ssm start-session --target i-002dc5db373054e04 --document-name AWS-StartPortForwardingSession --parameters "portNumber=80,localPortNumber=8081"

aws s3 ls

aws s3 ls s3://069057294951-demo-eu-west-1/ --recursive

sudo systemctl status httpd

curl http://localhost

terraform destroy --auto-approve

terraform-docs markdown table --output-file README.md .

aws sts get-caller-identity

ssh -i private-key/eks-terraform-key.pem ec2-user@52.91.108.4

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

kubectl port-forward ua-app-v1-6cdc7f94d8-qvhp2 8080:8080

curl http://localhost:8080/api/devices

curl http://34.229.116.170:30080/api/devices

ssh -i private-key/eks-terraform-key.pem ec2-user@3.84.213.237

