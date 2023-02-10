#####################
# REST API
#####################
resource "aws_lambda_function" "rest_api" {
  function_name = var.project_name
  s3_bucket = aws_s3_bucket.rest_api_source.id
  s3_key    = aws_s3_object.rest_api_source.key
  runtime = "nodejs12.x"
  handler = "index.handler"
  source_code_hash = data.archive_file.rest_api_source.output_base64sha256
  role = aws_iam_role.lambda_exec_rest_api.arn
  environment {
    variables = {
      stage = terraform.workspace
    }
  }
}

resource "aws_cloudwatch_log_group" "rest_api" {
  name = "/aws/lambda/${aws_lambda_function.rest_api.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec_rest_api" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_rest_api" {
  role       = aws_iam_role.lambda_exec_rest_api.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
