data "aws_caller_identity" "current" {}

#####################
# API Gateway
#####################
resource "aws_api_gateway_authorizer" "authorizer" {
  name                   = "authorizer"
  type                   = "TOKEN"
  rest_api_id            = aws_api_gateway_rest_api.api.id
  authorizer_uri         = aws_lambda_function.authorizer.invoke_arn
  authorizer_credentials = aws_iam_role.authorizer_role.arn
}





#####################
# S3
#####################
resource "aws_s3_bucket" "authorizer_source" {
  bucket = "${var.project_name}-authorizer"
  tags = {
    Name        = "My bucket for API Gateway custom authorizer source code"
    Environment = terraform.workspace
  }
}

resource "aws_s3_bucket_acl" "authorizer" {
  bucket = aws_s3_bucket.authorizer_source.id
  acl    = "private"
}


data "archive_file" "authorizer_source" {
  type        = "zip"
  source_dir  = "../authorizer/${path.module}"
  output_path = "../dist/${path.module}/authorizer-source.zip"
}

resource "aws_s3_object" "authorizer_source" {
  bucket = aws_s3_bucket.authorizer_source.id
  key    = "authorizer-source.zip"
  source = data.archive_file.authorizer_source.output_path
  etag   = filemd5(data.archive_file.authorizer_source.output_path)
}





#####################
# Lambda
#####################
data "aws_iam_policy_document" "assume_authorizer_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "apigateway.amazonaws.com",
        "lambda.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "authorizer_policy" {
  statement {
    actions   = ["lambda:InvokeFunction"]
    resources = [aws_lambda_function.authorizer.arn]
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${aws_lambda_function.authorizer.function_name}"
  retention_in_days = var.cloudwatch_log_group_retention_in_days
}

resource "aws_lambda_function" "authorizer" {
  function_name    = "${var.project_name}_authorizer"
  s3_bucket        = aws_s3_bucket.authorizer_source.id
  s3_key           = aws_s3_object.authorizer_source.key
  runtime          = "nodejs12.x"
  handler          = "index.handler"
  source_code_hash = data.archive_file.authorizer_source.output_base64sha256
  role             = aws_iam_role.authorizer_role.arn
  environment {
    variables = {
      stage = terraform.workspace
    }
  }
}




resource "aws_iam_role" "authorizer_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_authorizer_role.json
  description        = "custom authorizer resource access"
  name               = var.lambda_role_name
  path               = var.lambda_role_path
}

resource "aws_iam_role_policy" "authorizer_policy" {
  name   = var.lambda_role_name
  policy = data.aws_iam_policy_document.authorizer_policy.json
  role   = aws_iam_role.authorizer_role.id
}

resource "aws_iam_role_policy_attachment" "lambda_authorizer_policies" {
  count      = length(var.lambda_role_policy_arns)
  policy_arn = element(var.lambda_role_policy_arns, count.index)
  role       = aws_iam_role.authorizer_role.name
}














variable lambda_role_path {
  description = "Lambda role path."
  default     = null
}

variable lambda_role_name {
  description = "Lambda role name."
  default     = "authorizer"
}


variable lambda_role_policy_arns {
  description = "Lambda role policy attachment ARNs."
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
}

variable cloudwatch_log_group_retention_in_days {
  description = "Days to retain logs in CloudWatch."
  default     = 30
}




















# resource "aws_lambda_permission" "authorizer_access" {
#   statement_id  = "AllowAuthorizerExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.authorizer.arn
#   principal     = "apigateway.amazonaws.com"
#   # source_arn    = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*/authorizers/*"
#   source_arn = aws_api_gateway_rest_api.api.arn
# }



# resource "aws_iam_role_policy_attachment" "lambda_policy_authorizer" {
#   role       = aws_iam_role.lambda_exec_authorizer.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }
