terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.68.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
#variable "environment" {
 # description = "Environment to deploy: devel, stage, prod"
#  type        = string
#}

#resource "aws_s3_bucket" "app_bucket" {
#  bucket = "my-app-devel-bucket"

 # versioning {
   # enabled = true
#  }
#  website {
#    index_document = "index.html"
#    error_document = "error.html"
  #}
#}
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = my-app-devel-bucket

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_object" "app_files" {
  for_each = fileset("./codebase/rdicidr-0.1.0/build", "*")

  bucket = my-app-devel-bucket
  key    = each.value
  source = "./codebase/rdicidr-0.1.0/build/${each.value}"
  etag   = filemd5("./codebase/rdicidr-0.1.0/build/${each.value}")
  acl    = "public-read"
}
