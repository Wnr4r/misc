import boto3
import json

def create_bucket(bucketName):
    client = boto3.client('s3')
    try:
        response = client.create_bucket(
            Bucket=bucketName,
                CreateBucketConfiguration={
                            'LocationConstraint': 'eu-west-1',
                                },
                )
    except AttributeError as e:
        response = "This is error msg"+ e
    return response


def generate_data(number_of_files, bucketName):
    client = boto3.client('s3')
    try:
        for n in range(number_of_files):
            filename = "dummy_file"+str(n)+".txt"
            with open(filename, 'w+b'):
                response = client.upload_file(filename,bucketName,filename)
    except ClientError as e:
        response = e
    return response


def get_objects(bucket_name, region):
    client = boto3.client('s3', region)
    paginator = client.get_paginator('list_objects_v2')
    responses = paginator.paginate(Bucket=bucket_name)
    res = []

    for response in responses:
        for resp in response['Contents']:
            res.append(resp['Key'])
    response = json.dumps(res)
    return response


print(get_objects("xcode-s3-boto3-trial","eu-west-1"))


#print(generate_data(1500,"xcode-s3-boto3-trial"))

#print(create_bucket("xcode-s3-boto3-trial"))
