resource "aws_cloudwatch_log_group" "ws_lambda_notification_connect" {
  name              = "/aws/lambda/${var.ws_lambda_notification_connect}"
  retention_in_days = var.logs_retention_in_days
}

resource "aws_cloudwatch_log_group" "ws_lambda_notification_disconnect" {
  name              = "/aws/lambda/${var.ws_lambda_notification_disconnect}"
  retention_in_days = var.logs_retention_in_days
}

resource "aws_cloudwatch_log_group" "ws_lambda_notification_sendMessage" {
  name              = "/aws/lambda/${var.ws_lambda_notification_sendMessage}"
  retention_in_days = var.logs_retention_in_days
}

resource "aws_cloudwatch_log_group" "ws_lambda_notification_notifyWebSocket" {
  name              = "/aws/lambda/${var.ws_lambda_notification_notifyWebSocket}"
  retention_in_days = var.logs_retention_in_days
}