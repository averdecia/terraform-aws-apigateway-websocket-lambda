resource "aws_sqs_queue" "ws_notification_sqs" {
  name                      = "ws_notification_callback"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 3600
  receive_wait_time_seconds = 0
#   redrive_policy = jsonencode({
#     deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
#     maxReceiveCount     = 4
#   })

  tags = {
    Environment = "prd"
  }
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.ws_notification_sqs.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.ws_notification_sqs.arn}"
    }
  ]
}
POLICY
}

resource "aws_lambda_event_source_mapping" "ws_notification_sqs_consumer_lambda" {
  event_source_arn = aws_sqs_queue.ws_notification_sqs.arn
  function_name    = aws_lambda_function.lambda_function_notifyWebSocket.arn

  depends_on = [
    aws_lambda_function.lambda_function_notifyWebSocket
  ]
}