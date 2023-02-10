variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-west-2"
}

variable "project_name" {
  type        = string
  description = "Project name to be used throughout the application"
  default     = "my-awesome-tf-api-gateway"
}

variable "api_version" {
  type        = string
  description = "Version for the REST API"
  default     = "v1"
}




