import boto3
import json
import random
import time

def publish_message():
    # connect to SQS
    sqs = boto3.resource('sqs', region_name='your_region_name')
    queue_url = 'your_queue_url'
    
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
