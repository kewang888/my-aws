# Create the S3 bucket with public access blocked
resource "aws_s3_bucket" "demo_s3_bucket" {
  bucket = "${data.aws_caller_identity.current.account_id}-demo-${var.aws_region}"
}

resource "aws_s3_object" "example" {
  bucket  = aws_s3_bucket.demo_s3_bucket.bucket
  key     = "test-object.txt"
  content = "This is a test object in the bucket."
}

# Attach a policy to allow access via the endpoint
resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.demo_s3_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.demo_s3_bucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.demo_s3_bucket.id}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceVpce" = aws_vpc_endpoint.s3_endpoint.id
          }
        }
      }
    ]
  })
}