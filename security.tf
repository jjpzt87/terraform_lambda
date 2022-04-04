### Data
data "aws_vpc" "this" {
  id = var.vpc_id
}

### Security
resource "aws_security_group" "this" {
  name        = "custom-${var.lambda_name}-sg"
  description = "Security group to allow access to the lambda"
  vpc_id      = var.vpc_id

  ingress {
    description = "https access from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [ data.aws_vpc.this.cidr_block ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

### Access
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name                = "custom-${var.lambda_name}-role"
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role_policy.json
  managed_policy_arns = []
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "custom-${var.lambda_name}-policy"
  description = "Policy for ${var.lambda_name} lambda"
  policy      = file("${path.module}/lambda-policy.json")
}