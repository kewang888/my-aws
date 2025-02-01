# Create the S3 bucket with public access blocked
resource "aws_s3_bucket" "demo_s3_bucket" {
  bucket = "${data.aws_caller_identity.current.account_id}-demo-${var.aws_region}"
}

resource "aws_s3_object" "example" {
  bucket  = aws_s3_bucket.demo_s3_bucket.bucket
  key     = "test-object.txt"
  content = "This is a test object in the bucket."
}