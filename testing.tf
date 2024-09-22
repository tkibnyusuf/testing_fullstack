provider "aws" {
  region = "us-east-1"
}

variable "environment" {
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

resource "aws_s3_bucket_object" "app_files" {
  for_each = fileset("./build", "*")

  bucket = aws_s3_bucket.app_bucket.bucket
  key    = each.value
  source = "./build/${each.value}"
  etag   = filemd5("./build/${each.value}")
  acl    = "public-read"
}

output "bucket_endpoint" {
  value = aws_s3_bucket.app_bucket.website_endpoint
}
