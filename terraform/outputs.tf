output "function_name" {
  description = "Name of the Lambda function."
  value       = aws_lambda_function.rest_api.function_name
}

output "base_url" {
  description = "Base URL for API Gateway stage."
  value       = "${aws_api_gateway_deployment.api_deployment.invoke_url}/api"
}


output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
