provider "aws" {
  access_key = "..."
  secret_key = "..."
  region     = "us-east-1" 
}

resource "aws_sqs_queue" {
  name                      = "tech_task_SQSqueue"
  delay_seconds             = 60
  max_message_size          = 262144
  message_retention_seconds = 100
  receive_wait_time_seconds = 10
  visibility_timeout_seconds = 300
  tags = {
    Environment = "sqs_techtask"
  }
}

# Create an SQS queue
resource "aws_sqs_queue" "tech_task_SQSqueue" {
  name = "tech_task_SQSqueue"
}

# Create a publisher service
resource "aws_cloudwatch_event_rule" "publisher_event_rule" {
  name        = "publisher-event-rule"
  description = "Правило события для публикации сообщений в SQS каждую минуту"

  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "publisher_event_target" {
  rule      = aws_cloudwatch_event_rule.publisher_event_rule.name
  target_id = "publisher-target"

  arn = aws_sqs_queue.tech_task_SQSqueue.arn
}

resource "aws_lambda_function" "publisher_lambda" {
  function_name = "publisher-lambda"
  runtime      = "python3.8"
  handler      = "lambda_function.lambda_handler"
  role         = aws_iam_role.publisher_lambda_role.arn
  timeout      = 10
  memory_size  = 128

  filename      = "publisher_lambda.zip"
  source_code_hash = filebase64sha256("publisher_lambda.zip")
}

resource "aws_lambda_permission" "publisher_lambda_permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.publisher_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.publisher_event_rule.arn
}

resource "aws_iam_role" "publisher_lambda_role" {
  name = "publisher-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "publisher_lambda_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.publisher_lambda_role.name
}
