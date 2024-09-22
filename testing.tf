provider "aws" {
  region = "us-east-1"  # Specify your AWS region
}

# Reference the existing S3 bucket
data "aws_s3_bucket" "app_bucket" {
  bucket = "my-app-devel-bucket "  # Replace with your existing bucket name
}

# Upload the build directory files to S3
resource "aws_s3_bucket_object" "build_files" {
  for_each = fileset("${path.module}/build", "**")

  bucket = data.aws_s3_bucket.app_bucket.bucket
  key    = each.value
  source = "${path.module}/build/${each.value}"
  acl    = "public-read"  # Adjust according to your needs
}

output "bucket_url" {
  value = data.aws_s3_bucket.app_bucket.website_endpoint
}
