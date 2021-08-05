resource "aws_dynamodb_table" "dynamo_table" {
  name = "smt_notifications"
  billing_mode = var.dynamo_info.billing_mode
  read_capacity = var.dynamo_info.read_capacity
  write_capacity = var.dynamo_info.write_capacity
  hash_key = "connectionId"

  attribute {
    name = "connectionId"
    type = "S"
  }

  ttl {
    attribute_name = "deleteAt"
    enabled        = true
  }

  tags = {
      name = "Notifications"
  }
}