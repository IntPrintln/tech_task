provider "aws" {
  region = "us-east-1"
}

resource "aws_sqs_queue" "example" {
  name                      = "tech_task_SQSqueue"
  delay_seconds             = 60
  max_message_size          = 262144
  message_retention_seconds = 100
  receive_wait_time_seconds = 10
  visibility_timeout_seconds = 300
  tags = {
    Environment = "production"
  }
}







