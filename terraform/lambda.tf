resource "aws_lambda_function" "lambda_function_connect" {
  filename = data.archive_file.zip_code.output_path
  function_name = var.ws_lambda_notification_connect
  role = aws_iam_role.lambda_notifications_role.arn
  handler = "handlers/connect.handler"

  source_code_hash = data.archive_file.zip_code.output_base64sha256
  runtime = "nodejs12.x"

  environment {
      variables = {
        DYNAMODB_CONNECTIONS_TABLE = aws_dynamodb_table.dynamo_table.name
        APIGATEWAY_WS_ID = aws_apigatewayv2_api.ws_smt_notification.id
        APIGATEWAY_WS_URL = "${aws_apigatewayv2_api.ws_smt_notification.id}.execute-api.${var.aws_info.region}.amazonaws.com"
        APIGATEWAY_WS_STAGE = var.ws_smt_notification_stage
        REGION = var.aws_info.region
      }
  }
  depends_on = [
    data.archive_file.zip_code,
    aws_apigatewayv2_api.ws_smt_notification,
    aws_dynamodb_table.dynamo_table,
    aws_cloudwatch_log_group.ws_lambda_notification_connect
  ]
}

resource "aws_lambda_function" "lambda_function_disconnect" {
  filename = data.archive_file.zip_code.output_path
  function_name = var.ws_lambda_notification_disconnect
  role = aws_iam_role.lambda_notifications_role.arn
  handler = "handlers/disconnect.handler"

  source_code_hash = data.archive_file.zip_code.output_base64sha256
  runtime = "nodejs12.x"

  environment {
      variables = {
        DYNAMODB_CONNECTIONS_TABLE = aws_dynamodb_table.dynamo_table.name
        APIGATEWAY_WS_ID = aws_apigatewayv2_api.ws_smt_notification.id
        APIGATEWAY_WS_URL = "${aws_apigatewayv2_api.ws_smt_notification.id}.execute-api.${var.aws_info.region}.amazonaws.com"
        APIGATEWAY_WS_STAGE = var.ws_smt_notification_stage
        REGION = var.aws_info.region
      }
  }

  depends_on = [
    data.archive_file.zip_code,
    aws_apigatewayv2_api.ws_smt_notification,
    aws_dynamodb_table.dynamo_table,
    aws_cloudwatch_log_group.ws_lambda_notification_disconnect
  ]
}

resource "aws_lambda_function" "lambda_function_sendMessage" {
  filename = data.archive_file.zip_code.output_path
  function_name = var.ws_lambda_notification_sendMessage
  role = aws_iam_role.lambda_notifications_role.arn
  handler = "handlers/sendMessage.handler"

  source_code_hash = data.archive_file.zip_code.output_base64sha256
  runtime = "nodejs12.x"

  environment {
      variables = {
        DYNAMODB_CONNECTIONS_TABLE = aws_dynamodb_table.dynamo_table.name
        APIGATEWAY_WS_ID = aws_apigatewayv2_api.ws_smt_notification.id
        APIGATEWAY_WS_URL = "${aws_apigatewayv2_api.ws_smt_notification.id}.execute-api.${var.aws_info.region}.amazonaws.com"
        APIGATEWAY_WS_STAGE = var.ws_smt_notification_stage
        REGION = var.aws_info.region
      }
  }

  depends_on = [
    data.archive_file.zip_code,
    aws_apigatewayv2_api.ws_smt_notification,
    aws_dynamodb_table.dynamo_table,
    aws_cloudwatch_log_group.ws_lambda_notification_sendMessage
  ]
}

resource "aws_lambda_function" "lambda_function_notifyWebSocket" {
  filename = data.archive_file.zip_code.output_path
  function_name = var.ws_lambda_notification_notifyWebSocket
  role = aws_iam_role.lambda_notifications_role.arn
  handler = "handlers/notifyWebSocket.handler"

  source_code_hash = data.archive_file.zip_code.output_base64sha256
  runtime = "nodejs12.x"

  environment {
      variables = {
        DYNAMODB_CONNECTIONS_TABLE = aws_dynamodb_table.dynamo_table.name
        APIGATEWAY_WS_ID = aws_apigatewayv2_api.ws_smt_notification.id
        APIGATEWAY_WS_URL = "${aws_apigatewayv2_api.ws_smt_notification.id}.execute-api.${var.aws_info.region}.amazonaws.com"
        APIGATEWAY_WS_STAGE = var.ws_smt_notification_stage
        REGION = var.aws_info.region
      }
  }

  depends_on = [
    data.archive_file.zip_code,
    aws_apigatewayv2_api.ws_smt_notification,
    aws_dynamodb_table.dynamo_table,
    aws_cloudwatch_log_group.ws_lambda_notification_notifyWebSocket
  ]
}