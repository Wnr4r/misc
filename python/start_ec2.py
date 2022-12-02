import boto3

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
        instance.start()
        print("The following EC2 instances is now in start state", instance.id)
