def get_tag(tags, key='Name'):

  if not tags: return ''

  for tag in tags:
  
    if tag['Key'] == key:
      return tag['Value']
    
  return ''


import boto3
import sys

instances_to_start = sys.argv[1:]

ec2 = boto3.resource("ec2")

regions = []
for region in ec2.meta.client.describe_regions()['Regions']:
    regions.append(region['RegionName'])


for region in regions:
    ec2 = boto3.resource("ec2", region_name=region)
    print("EC2 region is:", region)

    ec2_instance = {"Name": "instance-state-name", "Values": ["stopped"]}

    instances = ec2.instances.filter(Filters=[ec2_instance])

    for instance in instances:
        instance_name = get_tag(instance.tags)
        if len(instances_to_start) > 0:
            for instance_to_start in instances_to_start:
                if instance_to_start == instance_name:
                    instance.start()
                    print("The following EC2 instances is now in start state", instance.id)
        else:
            instance.start()
            print("The following EC2 instances is now in start state", instance.id)

        

