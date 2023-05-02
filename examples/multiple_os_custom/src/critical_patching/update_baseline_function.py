'''Critical SSM Patching function Lambda Function'''

import boto3
import logging
import os
# from aws_xray_sdk.core import patch_all, xray_recorder
from critical_patching.ec2s import get_instance_ids_for_patch_group, update_instance_tags

ec2_client = boto3.client('ec2', region_name=os.environ.get('AWS_DEFAULT_REGION', 'eu-west-2'))

log_level = os.environ.get('LOGGING_LEVEL', logging.INFO)

logger = logging.getLogger(__name__)
logger.setLevel(log_level)
# patch_all()

# @xray_recorder.capture('critical_patching')
def lambda_handler(event, context):
    '''Main function'''
    try:
        patch_group = event['patch_group']
        instance_ids = get_instance_ids_for_patch_group(ec2_client, patch_group_tag_value=patch_group)
        logger.info(f'Instance IDs for {patch_group}: {instance_ids}')
        updated_tag_value = f'CRITICAL_{patch_group}'
        update_instance_tags(ec2_client, instance_ids, delete_patch_group_tag_value=patch_group, replace_with_value=updated_tag_value)
        return instance_ids

    except Exception as e:
        logger.error(e)
        raise e
