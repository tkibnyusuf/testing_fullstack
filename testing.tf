provider "aws" {
  region = "us-east-1"  # Specify your AWS region
}


# Reference the existing S3 bucket
data "aws_s3_bucket" "app_bucket" {
  bucket = "my-app-devel-bucket"  # Replace with your existing bucket name
}
resource "aws_s3_bucket_object" "build_files" {
  for_each = fileset("/home/runner/work/testing_fullstack/testing_fullstack/build", "**")

  bucket = data.aws_s3_bucket.app_bucket.bucket
  key    = each.value
  source = "/home/runner/work/testing_fullstack/testing_fullstack/build/${each.value}"
  acl    = "public-read"
  }
output "bucket_url" {
  value = data.aws_s3_bucket.app_bucket.website_endpoint
}
