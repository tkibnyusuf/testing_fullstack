provider "aws" {
  region = "us-east-1"
}
#variable "environment" {
 # description = "Environment to deploy: devel, stage, prod"
#  type        = string
#}

resource "aws_s3_bucket" "app_bucket" {
  bucket = "my-app-devel-bucket"
  acl    = "public-read"

  versioning {
    enabled = true
  }
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.app_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
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
