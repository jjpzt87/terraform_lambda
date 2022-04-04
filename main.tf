### Data
data "aws_caller_identity" "current" {}

data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id

  tags = {
    Tier = "Private"
  }
}

### Lambda
module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  # General Settings
  function_name           = "${var.lambda_name}"
  description             = "Lambda for ${var.lambda_name}"
  timeout                 = var.timeout

  # Codebase Settings
  create_package          = false
  image_uri               = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.image_path}"
  package_type            = "Image"

  # Access Settings
  lambda_role             = aws_iam_role.lambda_role.arn
  attach_network_policy   = true

  # Security Settings
  vpc_subnet_ids          = data.aws_subnet_ids.private.ids
  vpc_security_group_ids  = [ aws_security_group.this.id ]

  tags                    = var.tags
}