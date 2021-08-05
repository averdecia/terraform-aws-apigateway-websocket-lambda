output "ws_url" {
  value = "${aws_apigatewayv2_api.ws_smt_notification.api_endpoint}/${var.ws_smt_notification_stage}"
}

output "sqs_url" {
  value = aws_sqs_queue.ws_notification_sqs.url
}

output "ws_queue_rest_endpoint" {
  value = "${aws_api_gateway_deployment.queue_notification_deployment.invoke_url}/${var.queue_notification_to_SQS_path}"
}