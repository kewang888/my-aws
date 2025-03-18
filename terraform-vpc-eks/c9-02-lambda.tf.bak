resource "aws_security_group" "lambda_eks_tester2_sg" {
  vpc_id = module.vpc2.vpc_id

  # Allow Lambda to make outbound requests (e.g., to a database)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_eks_tester2_role" {
  name = "lambda_eks_tester2_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_vpc2_execution" {
  name       = "lambda_vpc2_execution"
  roles      = [aws_iam_role.lambda_eks_tester2_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_policy" "eks_describe_policy2" {
  name        = "EKSDescribePolicy2"
  description = "Allows describing the EKS cluster"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "eks:DescribeCluster"
        Resource = "arn:aws:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${aws_eks_cluster.eks_cluster.name}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy_attachment2" {
  role       = aws_iam_role.lambda_eks_tester2_role.name
  policy_arn = aws_iam_policy.eks_describe_policy2.arn
}

# Lambda Function inside VPC
resource "aws_lambda_function" "lambda_eks_tester2" {
  function_name    = "lambda_eks_tester2"
  role             = aws_iam_role.lambda_eks_tester2_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")

  # Attach Lambda to VPC
  vpc_config {
    subnet_ids         = module.vpc2.private_subnets
    security_group_ids = [aws_security_group.lambda_eks_tester2_sg.id]
  }

  environment {
    variables = {
      ENV_VAR = "value"
    }
  }
}