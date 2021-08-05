resource "aws_iam_role" "lambda_notifications_role" {
  name = "lambda_notifications_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

data "template_file" "lambda_policy" {
  template = file("policies/lambda_permissions.json")

  vars = {
    sqs_arn   = aws_sqs_queue.ws_notification_sqs.arn
    region   = data.aws_region.current.name
    account_id   = data.aws_caller_identity.current.account_id
    api_execution_arn   = aws_apigatewayv2_api.ws_smt_notification.execution_arn
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name = "smt_notifications_lambda_policy"

  policy = data.template_file.lambda_policy.rendered
}

resource "aws_iam_role_policy_attachment" "lambda_notifications_role_policy" {
  role       = aws_iam_role.lambda_notifications_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
