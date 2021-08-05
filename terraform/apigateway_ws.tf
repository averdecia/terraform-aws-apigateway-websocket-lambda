resource "aws_apigatewayv2_api" "ws_smt_notification" {
    name = "ws_smt_notification"
    protocol_type = "WEBSOCKET"
    route_selection_expression = "$request.body.action"
}

# Integrations
resource "aws_apigatewayv2_integration" "ws_integration_connect" {
  integration_method = "POST"
  integration_type = "AWS_PROXY"
  api_id = aws_apigatewayv2_api.ws_smt_notification.id
  integration_uri = aws_lambda_function.lambda_function_connect.invoke_arn
  depends_on = [
    aws_lambda_function.lambda_function_connect
  ]
}

resource "aws_apigatewayv2_integration" "ws_integration_disconnect" {
  integration_method = "POST"
  integration_type = "AWS_PROXY"
  api_id = aws_apigatewayv2_api.ws_smt_notification.id
  integration_uri = aws_lambda_function.lambda_function_disconnect.invoke_arn
  depends_on = [
    aws_lambda_function.lambda_function_disconnect
  ]
}

resource "aws_apigatewayv2_integration" "ws_integration_sendMessage" {
  integration_method = "POST"
  integration_type = "AWS_PROXY"
  api_id = aws_apigatewayv2_api.ws_smt_notification.id
  integration_uri = aws_lambda_function.lambda_function_sendMessage.invoke_arn
  depends_on = [
    aws_lambda_function.lambda_function_sendMessage
  ]
}

# Routes
resource "aws_apigatewayv2_route" "ws_smt_route_connect" {
  api_id    = aws_apigatewayv2_api.ws_smt_notification.id
  route_key = "$connect"
  operation_name = "ConnectRoute"
  target = "integrations/${aws_apigatewayv2_integration.ws_integration_connect.id}"
  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "ws_smt_route_disconnect" {
  api_id    = aws_apigatewayv2_api.ws_smt_notification.id
  route_key = "$disconnect"
  operation_name = "ConnectRoute"
  target = "integrations/${aws_apigatewayv2_integration.ws_integration_disconnect.id}"
  authorization_type = "NONE"
}

resource "aws_apigatewayv2_route" "ws_smt_route_sendMessage" {
  api_id    = aws_apigatewayv2_api.ws_smt_notification.id
  route_key = "sendMessage"
  operation_name = "ConnectRoute"
  target = "integrations/${aws_apigatewayv2_integration.ws_integration_sendMessage.id}"
  authorization_type = "NONE"
}

# Deployments
resource "aws_apigatewayv2_deployment" "ws_smt_notification_deployment" {
  api_id = aws_apigatewayv2_api.ws_smt_notification.id
  description = "Send new code to AWS"

  lifecycle {
    create_before_destroy = true
  }
   # Redeploy when there are new updates
  triggers = {
    redeployment = sha1(jsonencode(aws_apigatewayv2_integration.ws_integration_sendMessage))
  }
  
  depends_on = [
    aws_apigatewayv2_route.ws_smt_route_connect,
    aws_apigatewayv2_route.ws_smt_route_disconnect,
    aws_apigatewayv2_route.ws_smt_route_sendMessage
  ]
}

resource "aws_apigatewayv2_stage" "ws_smt_notification_stage" {
  name = var.ws_smt_notification_stage
  api_id = aws_apigatewayv2_api.ws_smt_notification.id
  deployment_id = aws_apigatewayv2_deployment.ws_smt_notification_deployment.id
  
  depends_on = [
    aws_apigatewayv2_api.ws_smt_notification
  ]
  default_route_settings {
    throttling_burst_limit   = 100
    throttling_rate_limit    = 1000
  }

  
}
