'''Critical SSM Patching function Lambda Function'''

import boto3
import logging
import os
import time
# from aws_xray_sdk.core import patch_all, xray_recorder

ec2_client = boto3.client('ec2')
ssm_client = boto3.client('ssm')

log_level = os.environ.get('LOGGING_LEVEL', logging.INFO)

logger = logging.getLogger(__name__)
logger.setLevel(log_level)
# patch_all()

# @xray_recorder.capture('critical_patching')
def lambda_handler(event, context):
    '''Main function'''
    try:
        baseline_name = f'{event["patch_group"]}_patch_baseline_install'.lower()
        print(baseline_name)

        association = ssm_client.list_associations(
            AssociationFilterList=[
                {
                    'key': 'AssociationName',
                    'value': baseline_name,
                },
            ]
        )

        association_id = association['Associations'][0]['AssociationId']

        ssm_client.start_associations_once(
            AssociationIds=[
                association_id,
            ]
        )

        time.sleep(5)

        response = ssm_client.describe_association_executions(
            AssociationId=association_id,
        )

        return response['AssociationExecutions'][0]['ExecutionId']

    except Exception as e:
        logger.error(e)
        raise e
