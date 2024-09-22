provider "aws" {
  region = "us-east-1"  # Specify your AWS region
}

# Reference the existing S3 bucket
data "aws_s3_bucket" "app_bucket" {
  bucket = "my-app-devel-bucket"  # Replace with your existing bucket name
}
