resource "aws_iam_role" "my_irsa" {
  name = "my-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.oidc_provider.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.aws_iam_oidc_connect_provider_extract_from_arn}:aud" = "sts.amazonaws.com"
            "${local.aws_iam_oidc_connect_provider_extract_from_arn}:sub" = "system:serviceaccount:default:my-service-account"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "irsa_s3_policy" {
  name = "irsa-s3-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.demo_s3_bucket.arn}/*",
          aws_s3_bucket.demo_s3_bucket.arn
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "s3:ListAllMyBuckets",
        "Resource" : "arn:aws:s3:::*"
      }
    ]
  })
}

# Attach the IAM policy to the role
resource "aws_iam_role_policy_attachment" "s3_attach_policy" {
  role       = aws_iam_role.my_irsa.name
  policy_arn = aws_iam_policy.irsa_s3_policy.arn
}