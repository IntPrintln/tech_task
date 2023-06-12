import boto3
import json
import random
import time

def publish_message():
    # connect to SQS
    sqs = boto3.resource('sqs', region_name='us-east-1')
    queue_url = 'https://us-east-1.console.aws.amazon.com/sqs/v2/home?region=us-east-1#/queues/https%3A%2F%2Fsqs.us-east-1.amazonaws.com%2F163825456495%2Ftech_task_SQSqueue'
    
    # genetration random string
    random_string = str(random.randint(1, 100))
    
    # meessage in JSON
    message = {
        'data': random_string
    }
    
    # Send message in SQS
    response = sqs.send_message(
        QueueUrl=queue_url,
        MessageBody=json.dumps(message)
    )
    
    print(f"Message sent: {response['MessageId']}")

while True:
    publish_message()
    time.sleep(60)
