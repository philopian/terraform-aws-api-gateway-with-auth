#####################
# REST API
#####################
resource "aws_s3_bucket" "rest_api_source" {
  bucket = var.project_name
  tags = {
    Name        = "My bucket for API Gateway source code"
    Environment = terraform.workspace
  }
}

resource "aws_s3_bucket_acl" "rest_api" {
  bucket = aws_s3_bucket.rest_api_source.id
  acl    = "private"
}

data "archive_file" "rest_api_source" {
  type        = "zip"
  source_dir  = "../rest-api/${path.module}"
  output_path = "../dist/${path.module}/rest-api-source.zip"
}

resource "aws_s3_object" "rest_api_source" {
  bucket = aws_s3_bucket.rest_api_source.id
  key    = "rest-api-source.zip"
  source = data.archive_file.rest_api_source.output_path
  etag   = filemd5(data.archive_file.rest_api_source.output_path)
}

