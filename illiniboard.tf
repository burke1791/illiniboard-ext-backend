
provider "aws" {
  profile = "burke02"
  region  = var.region
}

resource "aws_instance" "illiniboard_ext" {
  ami           = var.amis[var.region]
  instance_type = "t2.micro"
  key_name      = var.key_pair
  tags = {
    Name = "illiniboard-extension"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.illiniboard_ext.public_ip} > ip_address.txt"
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "illiniboard_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "rssPoll" {
  function_name = "IlliniboardRSSPoll"

  s3_bucket = var.s3_bucket_lambda
  s3_key    = "v${var.app_version}/rssPoll.zip"

  handler = "rssPoll.handler"
  runtime = var.lambda_runtime

  role = aws_iam_role.lambda_exec.arn

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs
  ]
}

resource "aws_lambda_function" "updateArticlesInDatabase" {
  function_name = "UpdateIBArticlesInDatabase"

  s3_bucket = var.s3_bucket_lambda
  s3_key    = "v${var.app_version}/updateArticlesInDatabase.zip"

  handler = "updateArticlesInDatabase.handler"
  runtime = var.lambda_runtime

  role = aws_iam_role.lambda_exec.arn

  vpc_config {
    subnet_ids         = var.lambda_subnet_ids
    security_group_ids = var.lambda_security_group_ids
  }

  environment {
    variables = var.lambda_env
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs
  ]
}

resource "aws_lambda_function" "registerNewExtension" {
  function_name = "RegisterNewExtension"

  s3_bucket = var.s3_bucket_lambda
  s3_key = "v${var.app_version}/registerNewExtension.zip"

  handler = "register.handler"
  runtime = var.lambda_runtime

  role = aws_iam_role.lambda_exec.arn

  vpc_config {
    subnet_ids         = var.lambda_subnet_ids
    security_group_ids = var.lambda_security_group_ids
  }

  environment {
    variables = var.lambda_env
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs
  ]
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.registerNewExtension.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.illiniboard.execution_arn}/*/*"
}

resource "aws_lambda_permission" "cloudwatch_events" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rssPoll.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.five_minutes.arn
}

resource "aws_lambda_permission" "lambda_invoke" {
  statement_id  = "AllowLambdaInvoking"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.updateArticlesInDatabase.function_name
  principal     = "lambda.amazonaws.com"
  source_arn    = aws_lambda_function.rssPoll.arn
}

resource "aws_lambda_permission" "lambda_invoke_2" {
  statement_id  = "AllowLambdaInvoking"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rssPoll.function_name
  principal     = "lambda.amazonaws.com"
  source_arn    = aws_lambda_function.rssPoll.arn
}

output "instance_ip" {
  value = aws_instance.illiniboard_ext.public_ip
}

output "base_url" {
  value = aws_api_gateway_deployment.illiniboard.invoke_url
}