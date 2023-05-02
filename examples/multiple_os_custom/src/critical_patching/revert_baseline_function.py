'''Critical SSM Patching function Lambda Function'''

import boto3
import logging
import os
# from aws_xray_sdk.core import patch_all, xray_recorder

ec2_client = boto3.client('ec2')

log_level = os.environ.get('LOGGING_LEVEL', logging.INFO)

logger = logging.getLogger(__name__)
logger.setLevel(log_level)
# patch_all()

def get_instance_ids(patch_group):
    '''Get the instance ID based on PatchGroup tags'''
    instances = ec2_client.describe_instances(
        Filters=[
            {
                'Name': 'tag:PatchGroup',
                'Values': [
                    f'CRITICAL_{patch_group}',
                ]
            },
        ]
    )

    instance_ids = []
    
    for reservation in instances['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            instance_ids.append(instance_id)

    return instance_ids

def update_instance_tags(instance_ids, patch_group):
    '''Update the instance tags'''

    for instance_id in instance_ids:
        ec2_client.delete_tags(
            Resources=[
                instance_id,
            ],
            Tags=[
                {
                    'Key': 'PatchGroup',
                    'Value': f'CRITICAL_{patch_group}'
                },
            ]
        )

        ec2_client.create_tags(
            Resources=[
                instance_id,
            ],
            Tags=[
                {
                    'Key': 'PatchGroup',
                    'Value': patch_group
                },
            ]
        )
    return f'Completed updating tags for {patch_group}: {instance_ids}'

# @xray_recorder.capture('critical_patching')
def lambda_handler(event, context):
    '''Main function'''
    try:
        patch_group = event['patch_group']
        instance_ids = get_instance_ids(patch_group)
        logger.info(f'Instance IDs for {patch_group}: {instance_ids}')
        update_instance_tags(instance_ids, patch_group)
        return instance_ids

    except Exception as e:
        logger.error(e)
        raise e
