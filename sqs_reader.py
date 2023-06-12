import boto3

def read_messages():
    # Connect to SQS
    sqs = boto3.resource('sqs', region_name='your_region_name')
    queue_url = 'your_queue_url'
    
    # Retrieve messages
    queue = sqs.Queue(queue_url)
    messages = queue.receive_messages(MaxNumberOfMessages=10)
    
    # Print messages to stdout
    for message in messages:
        print(f"Received message: {message.body}")
        message.delete()

# start reading message
read_messages()
