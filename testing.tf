provider "aws" {
  region = "us-east-1"  # Specify your AWS region
}

# Create a remote backend for your terraform 
terraform {
  backend "s3" {
    bucket = "yusuf-docker-tfstate"
    dynamodb_table = "app-state"
    key    = "LockID"
    region = "us-east-1"
    profile = "yusuf"
  }
}
variable "environment_name" {
  description = "Environment to deploy: devel, stage, prod"
  type        = string
}


resource "aws_s3_bucket" "app_bucket" {
  bucket = "my-app-${var.environment}-bucket"
  acl    = "public-read"

  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}
resource "aws_s3_bucket_object" "build_files" {
  for_each = fileset("/home/runner/work/testing_fullstack/testing_fullstack/build", "**")

  bucket = aws_s3_bucket.app_bucket.bucket
  key    = each.value
  source = "/home/runner/work/testing_fullstack/testing_fullstack/build/${each.value}"
  acl    = "public-read"
  }
output "bucket_url" {
  value = aws_s3_bucket.app_bucket.website_endpoint
}
