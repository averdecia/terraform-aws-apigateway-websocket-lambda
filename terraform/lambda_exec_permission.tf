resource "aws_lambda_permission" "lambda_permission_for_ws_connect" {
    function_name = aws_lambda_function.lambda_function_connect.function_name
    action = "lambda:InvokeFunction"
    principal = "apigateway.${var.aws_info.region}.amazonaws.com"
    source_arn = "${aws_apigatewayv2_api.ws_smt_notification.execution_arn}/*/$connect"
    depends_on = [
      aws_lambda_function.lambda_function_connect
    ]
}

resource "aws_lambda_permission" "lambda_permission_for_ws_disconnect" {
    function_name = aws_lambda_function.lambda_function_disconnect.function_name
    action = "lambda:InvokeFunction"
    principal = "apigateway.${var.aws_info.region}.amazonaws.com"
    source_arn = "${aws_apigatewayv2_api.ws_smt_notification.execution_arn}/*/$disconnect"
    depends_on = [
      aws_lambda_function.lambda_function_disconnect
    ]
}

resource "aws_lambda_permission" "lambda_permission_for_ws_sendMessage" {
    function_name = aws_lambda_function.lambda_function_sendMessage.function_name
    action = "lambda:InvokeFunction"
    principal = "apigateway.amazonaws.com"
    source_arn = "${aws_apigatewayv2_api.ws_smt_notification.execution_arn}/*/sendMessage"
    depends_on = [
      aws_lambda_function.lambda_function_sendMessage
    ]
}