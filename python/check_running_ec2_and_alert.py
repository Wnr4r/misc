import boto3
from botocore.exceptions import ClientError
import json

#my tag function
def get_tag(tags, key='Name'):

  if not tags: return ''

  for tag in tags:
  
    if tag['Key'] == key:
      return tag['Value']
    
  return ''
 
def lambda_handler(event, context):
    # Connect to EC2 client
    ec2 = boto3.client('ec2')
    try:
        # Get a list of all running instances
        instances = ec2.describe_instances(Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])
        instance_names = []
        instance_name_tag = []
        instance_list = []
        for reservation in instances['Reservations']:
            for instance in reservation['Instances']:
                instance_names.append(instance['InstanceId'])
                instance_name_tag.append(get_tag(instance['Tags']))
                instance_list.append((get_tag(instance['Tags']), instance['InstanceId']))
        
        # Connect to SNS client
        sns = boto3.client('sns')
        if len(instance_names) > 0:
            # Compose message
            #message = "The following instances are running: " + ", ".join(instance_name_tag)
            message = "The following instances are running: "
            for instance in instance_list:
                message+=f'\n {instance[0]} - {instance[1]},'
            # Send SMS message
            sns.publish(
               PhoneNumber='+37253912498',
              Message=message
            )
        else:
            message = "No instance is currently running"
        return {
        'statusCode': 200,
        'body': json.dumps(message)
        }
    except ClientError as e:
        print(e)

