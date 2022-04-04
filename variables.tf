# Lambda
variable "lambda_name" {
  type        = string
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type = number
  default = 120
}

variable vpc_id {
  description = "VPC where the lambdas will be deployed"
  type        = string
}

# ECR
variable region {
  description = "AWS Region"
  type        = string
  default     = "eu-west-1"
}

variable image_path {
  description = "path to the desired base image"
  type        = string
}

# CostAnalysis
variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}