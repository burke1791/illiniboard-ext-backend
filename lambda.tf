
resource "aws_iam_policy" "lambda_invoke" {
  name        = "lambda_invoke"
  path        = "/"
  description = "IAM policy for invoking a lambda from another lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:InvokeFunction"
      ],
      "Resource": [
        "${aws_lambda_function.rssPoll.arn}",
        "${aws_lambda_function.updateArticlesInDatabase.arn}",
        "${aws_lambda_function.root.arn}",
        "${aws_lambda_function.registerNewExtension.arn}",
        "${aws_lambda_function.checkNewArticles.arn}"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_invoke" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_invoke.arn
}

resource "aws_iam_policy" "lambda_deploy_in_vpc" {
  name        = "lambda_vpc_deploy"
  path        = "/"
  description = "IAM policy allowing for vpc deployment"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeNetworkInterfaces",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeInstances",
        "ec2:AttachNetworkInterface"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_deploy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_deploy_in_vpc.arn
}