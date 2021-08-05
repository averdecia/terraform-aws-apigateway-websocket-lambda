resource "aws_api_gateway_rest_api" "queue_notification_to_SQS" {
  name        = "api-gateway-SQS"
  description = "POST records to SQS queue directly"
}

resource "aws_api_gateway_resource" "queue_path" {
    rest_api_id = aws_api_gateway_rest_api.queue_notification_to_SQS.id
    parent_id   = aws_api_gateway_rest_api.queue_notification_to_SQS.root_resource_id
    path_part   = var.queue_notification_to_SQS_path
}

resource "aws_api_gateway_method" "method_queue_notification" {
    rest_api_id   = aws_api_gateway_rest_api.queue_notification_to_SQS.id
    resource_id   = aws_api_gateway_resource.queue_path.id
    http_method   = "POST"
    authorization = "NONE"

    request_parameters = {
      "method.request.path.proxy"        = false
      "method.request.querystring.unity" = false
  }

#   request_validator_id = aws_api_gateway_request_validator.validator_query.id
}

resource "aws_api_gateway_integration" "queue_notification_API_to_SQS_integration" {
  rest_api_id             = aws_api_gateway_rest_api.queue_notification_to_SQS.id
  resource_id             = aws_api_gateway_resource.queue_path.id
  http_method             = aws_api_gateway_method.method_queue_notification.http_method
  type                    = "AWS"
  integration_http_method = "POST"
  credentials             = aws_iam_role.apiSQS.arn
  uri                     = "arn:aws:apigateway:${var.aws_info.region}:sqs:path/${aws_sqs_queue.ws_notification_sqs.name}"

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  # Request Template for passing Method, Body, QueryParameters and PathParams to SQS messages
  request_templates = {
    "application/json" = <<EOF
Action=SendMessage&MessageBody={"body": $input.json('$')}
EOF
  }

  depends_on = [
    aws_iam_role_policy_attachment.api_exec_role
  ]
}

# SQS Response
resource "aws_api_gateway_method_response" "http200" {
 rest_api_id = aws_api_gateway_rest_api.queue_notification_to_SQS.id
 resource_id = aws_api_gateway_resource.queue_path.id
 http_method = aws_api_gateway_method.method_queue_notification.http_method
 status_code = 200
}

resource "aws_api_gateway_integration_response" "http200" {
 rest_api_id       = aws_api_gateway_rest_api.queue_notification_to_SQS.id
 resource_id       = aws_api_gateway_resource.queue_path.id
 http_method       = aws_api_gateway_method.method_queue_notification.http_method
 status_code       = aws_api_gateway_method_response.http200.status_code
 selection_pattern = "^2[0-9][0-9]"                                       // regex pattern for any 200 message that comes back from SQS

 depends_on = [
   aws_api_gateway_integration.queue_notification_API_to_SQS_integration
   ]
}

resource "aws_api_gateway_deployment" "queue_notification_deployment" {
 rest_api_id = aws_api_gateway_rest_api.queue_notification_to_SQS.id
 stage_name  = var.ws_smt_notification_stage

 depends_on = [
   aws_api_gateway_integration.queue_notification_API_to_SQS_integration,
 ]

 # Redeploy when there are new updates
 triggers = {
   redeployment = sha1(jsonencode(aws_api_gateway_integration.queue_notification_API_to_SQS_integration))
 }

 lifecycle {
   create_before_destroy = true
 }
}