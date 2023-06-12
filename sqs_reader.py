import boto3

def read_messages():
    # Connect to SQS
    sqs = boto3.resource('sqs', region_name='us-east-1')
    queue_url = 'https://us-east-1.console.aws.amazon.com/sqs/v2/home?region=us-east-1#/queues/https%3A%2F%2Fsqs.us-east-1.amazonaws.com%2F163825456495%2Ftech_task_SQSqueue'
    
    # Retrieve messages
    queue = sqs.Queue(queue_url)
    messages = queue.receive_messages(MaxNumberOfMessages=10)
    
    # Print messages to stdout
    for message in messages:
        print(f"Received message: {message.body}")
        message.delete()

# start reading message
read_messages()
