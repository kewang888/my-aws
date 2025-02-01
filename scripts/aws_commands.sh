#Using AWS CLI to Get Amazon Linux 2 AMI with SSM Agent
aws ssm get-parameters-by-path --path "/aws/service/ami-amazon-linux-latest" --query "Parameters[*].{Name:Name,Value:Value}"

aws ssm start-session --target i-xxxxxxxxxx