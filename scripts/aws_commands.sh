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

kubectl version --client

aws eks update-kubeconfig --region eu-west-1 --name my-cluster

export KUBECONFIG=/Users/kwang04/my-projects/my-aws/eks/my-kubeconfig
aws eks update-kubeconfig --region eu-west-1 --name my-cluster
#Added new context arn:aws:eks:eu-west-1:069057294951:cluster/my-cluster to /Users/kwang04/my-projects/my-aws/eks/my-kubeconfig

kubectl get configmap aws-auth -n kube-system -o yaml


aws:eks:cluster-name
my-cluster
aws:autoscaling:groupName
eks-my-nodegroup-56ca6438-5e5e-ad85-b334-8b2c8c4dc56f
aws:ec2:fleet-id
fleet-943d97be-a0ac-cead-8eb0-8b0a6b5713c8
k8s.io/cluster-autoscaler/enabled
true
aws:ec2launchtemplate:version
1
k8s.io/cluster-autoscaler/my-cluster
owned
aws:ec2launchtemplate:id
lt-0a6c2464ce6a382a5
kubernetes.io/cluster/my-cluster
owned
eks:cluster-name
my-cluster
eks:nodegroup-name
my-nodegroup


