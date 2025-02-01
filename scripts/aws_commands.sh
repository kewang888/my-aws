#Using AWS CLI to Get Amazon Linux 2 AMI with SSM Agent
aws ssm get-parameters-by-path --path "/aws/service/ami-amazon-linux-latest" --query "Parameters[*].{Name:Name,Value:Value}"

aws ssm start-session --target i-0b4f29eb3fa115410

aws s3 ls

aws s3 ls s3://069057294951-demo-eu-west-1/ --recursive

sudo systemctl status httpd

curl -I http://localhost
