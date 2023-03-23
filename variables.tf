variable "env" {
  type        = string
  description = "The environment the module is used for demo/dev/prod"
}

variable "region" {
  type = string
  description = "The region in which to create/manage resources"
  default = "us-east-1"
}

variable "account_id" {
  type        = string
  description = "The account ID in which to create/manage resources"
}

variable "function_name" {
  type        = string
  description = "The name of the Lambda function"
}

variable "rest_api_stage_name" {
  type        = string
  description = "The name of the API Gateway stage"
}
