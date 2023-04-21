'''Critical SSM Patching function Lambda Function'''

import boto3
import logging
import os
from aws_xray_sdk.core import patch_all, xray_recorder

ec2_client = boto3.client('ec2')

log_level = os.environ.get('LOGGING_LEVEL', logging.INFO)

logger = logging.getLogger(__name__)
logger.setLevel(log_level)
patch_all()

@xray_recorder.capture('critical_patching')
def lambda_handler(event, context):
    '''Main function'''
    try:
        pass
        return "Completed IAM Checker"

    except Exception as e:
        logger.error(e)
        raise e
