#Using AWS CLI to Get Amazon Linux 2 AMI with SSM Agent
aws ssm get-parameters-by-path --path "/aws/service/ami-amazon-linux-latest" --query "Parameters[*].{Name:Name,Value:Value}"

aws ssm start-session --target i-0e64b74632580b41b

aws s3 ls

aws s3 ls s3://069057294951-demo-us-east-1/ --recursive
