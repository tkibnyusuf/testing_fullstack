provider "aws" {
  region = "us-east-1"  # Specify your AWS region
}

# Reference the existing S3 bucket
data "aws_s3_bucket" "app_bucket" {
  bucket = "my-app-devel-bucket"  # Replace with your existing bucket name
}
resource "aws_s3_bucket_object" "build_files" {
  for_each = fileset("${path.module}/codebase/rdicidr-0.1.0/build", "**")

  bucket = data.aws_s3_bucket.app_bucket.bucket
  key    = each.value
  source = "${path.module}/codebase/rdicidr-0.1.0/build/${each.value}"

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
    substr(each.value, length(each.value) - 5, 5), # Get the last part of the file name (extension)
    "application/octet-stream" # Default if not matched
  )
}
output "bucket_url" {
  value = data.aws_s3_bucket.app_bucket.website_endpoint
}
