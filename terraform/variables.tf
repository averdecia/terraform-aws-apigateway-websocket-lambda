variable "aws_info" {
  type = object({
    region    = string
  })

  sensitive = true

  default = {
      region = "us-west-2"
  }
}

variable "dynamo_info" {
    type = object({
        billing_mode    = string
        read_capacity   = number
        write_capacity  = number
    })
    description = "Used to save all dynamo db configurations"
    default = {
        billing_mode    = "PROVISIONED"
        read_capacity   = 5
        write_capacity  = 5
    }
}

variable "ws_lambda_notification_connect" {
    type = string
    description = "Used to name the variable in the AWS console"
    default = "ws_smt_notification_connect"
}

variable "ws_lambda_notification_disconnect" {
    type = string
    description = "Used to name the variable in the AWS console"
    default = "ws_smt_notification_disconnect"
}

variable "ws_lambda_notification_sendMessage" {
    type = string
    description = "Used to name the variable in the AWS console"
    default = "ws_smt_notification_sendMessage"
}

variable "ws_lambda_notification_notifyWebSocket" {
    type = string
    description = "Used to name the variable in the AWS console"
    default = "ws_smt_notification_notifyWebSocket"
}

variable "ws_lambda_notification_queueMessage" {
    type = string
    description = "Used to name the variable in the AWS console"
    default = "ws_smt_notification_queueMessage"
}

variable "ws_apigateway_logs" {
    type = string
    description = "Used to name the variable in the AWS console"
    default = "ws_apigateway_logs"
}

variable "logs_retention_in_days" {
    type = number
    description = "Time to retain logs in cloudwatch"
    default = 5
}

variable "ws_smt_notification_stage" {
    type = string
    description = "Release environment"
    default = "prd"
}

variable "queue_notification_to_SQS_path" {
    type = string
    description = "Callback url for notification"
    default = "queue"
}