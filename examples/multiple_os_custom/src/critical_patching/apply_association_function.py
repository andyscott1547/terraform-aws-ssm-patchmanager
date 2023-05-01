'''Critical SSM Patching function Lambda Function'''

import boto3
import logging
import os
import time
# from aws_xray_sdk.core import patch_all, xray_recorder

ssm_client = boto3.client('ssm', region_name=os.environ.get('AWS_DEFAULT_REGION', 'eu-west-2'))

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

        return association_id

    except Exception as e:
        logger.error(e)
        raise e
