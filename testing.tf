provider "aws" {
  region = "us-east-1"  # Specify your AWS region
}


# Create a remote backend for your terraform 
terraform {
  backend "s3" {
    bucket = "yusuf-docker-tfstate"
    key =  "full/terraform.tfstate"
    region = "us-east-1"

  }
}

variable "environment_name" {
  description = "Environment to deploy: devel, stage, prod"
  type        = string
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = "my-app-${var.environment_name}-bucket"

  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.app_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_object" "build_files" {
  for_each = fileset("/home/runner/work/testing_fullstack/testing_fullstack/build", "**")

  bucket = aws_s3_bucket.app_bucket.bucket
  key    = each.value
  source = "/home/runner/work/testing_fullstack/testing_fullstack/build/${each.value}"
  acl    = "public-read"
 # Set content-type based on file extension
  content_type = lookup(
    {
      ".html" = "text/html",
      ".css"  = "text/css",
      ".js"   = "application/javascript",
      ".json" = "application/json",
      ".png"  = "image/png",
      ".jpg"  = "image/jpeg"
    },
    substr(each.value, length(each.value) - 5, 5),
    "application/octet-stream" # Default if not matched
  )
  }
output "bucket_url" {
  value = aws_s3_bucket.app_bucket.website_endpoint
}
