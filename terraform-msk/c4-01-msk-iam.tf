resource "aws_iam_role" "msk_client_machine_role" {
  name = "msk_client_machine_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "kafka_policy" {
  name        = "KafkaAccessPolicy"
  description = "IAM policy for accessing MSK"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kafka-cluster:Connect",
          "kafka-cluster:AlterCluster",
          "kafka-cluster:DescribeCluster"
        ],
        Resource = "arn:aws:kafka:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/MSKTutorialCluster/*"
      },
      {
        Effect = "Allow",
        Action = [
          "kafka-cluster:*Topic*",
          "kafka-cluster:WriteData",
          "kafka-cluster:ReadData"
        ],
        Resource = "arn:aws:kafka:${var.aws_region}:${data.aws_caller_identity.current.account_id}:topic/MSKTutorialCluster/*"
      },
      {
        Effect = "Allow",
        Action = [
          "kafka-cluster:AlterGroup",
          "kafka-cluster:DescribeGroup"
        ],
        Resource = "arn:aws:kafka:${var.aws_region}:${data.aws_caller_identity.current.account_id}:group/MSKTutorialCluster/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_kafka_policy" {
  role       = aws_iam_role.msk_client_machine_role.name
  policy_arn = aws_iam_policy.kafka_policy.arn
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "msk_client_machine_instance_profile" {
  name = "msk-client-machine-instance-profile"
  role = aws_iam_role.msk_client_machine_role.name
}
