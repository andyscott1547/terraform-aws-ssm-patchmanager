'''Critical SSM Patching function Lambda Function'''

import boto3
import logging
import os
from critical_patching.ec2s import get_instance_ids_for_patch_group, update_instance_tags
# from aws_xray_sdk.core import patch_all, xray_recorder

ec2_client = boto3.client('ec2', region_name=os.environ.get('AWS_DEFAULT_REGION', 'eu-west-2'))

log_level = os.environ.get('LOGGING_LEVEL', logging.INFO)

logger = logging.getLogger(__name__)
logger.setLevel(log_level)

# @xray_recorder.capture('critical_patching')
def lambda_handler(event, context):
    '''Main function'''
    try:
        patch_group = event['patch_group']
        tag_value = f'CRITICAL_{patch_group}'
        instance_ids = get_instance_ids_for_patch_group(ec2_client, patch_group_tag_value=tag_value)
        logger.info(f'Instance IDs for {patch_group}: {instance_ids}')
        update_instance_tags(ec2_client, instance_ids, delete_patch_group_tag_value=tag_value, replace_with_value=patch_group)
        return instance_ids

    except Exception as e:
        logger.error(e)
        raise e
