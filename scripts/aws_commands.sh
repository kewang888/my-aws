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