provider "aws" {
  access_key = "..."
  secret_key = "..."
  region     = "us-east-1" 
}

# Create a reader service
resource "aws_lambda_function" "reader_lambda" {
  function_name = "reader-lambda"
  runtime      = "python3.8"
  handler      = "lambda_function.lambda_handler"
  role         = aws_iam_role.reader_lambda_role.arn
  timeout      = 10
  memory_size  = 128

  filename      = "reader_lambda.zip"
  source_code_hash = filebase64sha256("reader_lambda.zip")
}

resource "aws_iam_role" "reader_lambda_role" {
  name = "reader-lambda-role"

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

resource "aws_iam_role_policy_attachment" "reader_lambda_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.reader_lambda_role.name
}

resource "aws_lambda_permission" "sqs_permission" {
  statement_id  = "AllowSQSInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.reader_lambda.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = aws_sqs_queue.tech_task_SQSqueue.arn
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = aws_sqs_queue.tech_task_SQSqueue.arn
  function_name    = aws_lambda_function.reader_lambda.function_name
  batch_size       = 1
}
