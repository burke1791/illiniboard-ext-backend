
resource "aws_cloudwatch_log_group" "root" {
  name              = "/aws/lambda/Root"
  retention_in_days = 7
}

# resource "aws_cloudwatch_log_group" "updateArticlesInDatabase" {
#   name              = "/aws/lambda/updateArticlesInDatabase"
#   retention_in_days = 7
# }

resource "aws_cloudwatch_event_rule" "five_minutes" {
  name                = "ten-minutes"
  description         = "fires every ten minutes"
  schedule_expression = "rate(10 minutes)"
}

resource "aws_cloudwatch_event_target" "rssPoll_every_five_minutes" {
  rule      = aws_cloudwatch_event_rule.five_minutes.name
  target_id = "lambda"
  arn       = aws_lambda_function.rssPoll.arn
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}