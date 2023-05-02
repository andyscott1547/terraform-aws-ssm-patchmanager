import boto3
import os
import re
from typing import List, Dict

def new_mocked_ec2_with_tags(tags: Dict[str,str]) -> str:
    ec2 = new_boto3_ec2_resource()
    new_instances: List[ec2.Instance] = ec2.create_instances(
      MinCount=1,
      MaxCount=1,
      InstanceType='t2.micro',
      TagSpecifications = [
          {
              "ResourceType": "instance",
              "Tags": [ tags ]
          }
      ]
    )
    assert len(new_instances) == 1
    assert re.match(".*eu-west-2.*\.compute\.amazonaws\.com", new_instances[0].public_dns_name)
    instance_id: str = new_instances[0].instance_id
    return instance_id

def new_boto3_ec2_resource():
    # https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2/service-resource/index.html
    ec2 = boto3.resource("ec2", region_name=os.environ.get('AWS_DEFAULT_REGION', 'eu-west-2'))
    assert boto3.session.botocore.session.get_session().get_credentials().secret_key == "foobar_secret" # confirm mocked client
    return ec2
