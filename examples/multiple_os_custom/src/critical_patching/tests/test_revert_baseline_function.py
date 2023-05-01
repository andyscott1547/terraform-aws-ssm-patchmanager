import os
import pytest
from moto import mock_ec2
from critical_patching.tests.ec2s_test_infra import new_boto3_ec2_resource, new_mocked_ec2_with_tags

@pytest.fixture
def mock_aws_environment(autouse=True):
    # https://docs.getmoto.org/en/latest/docs/getting_started.html#how-do-i-avoid-tests-from-mutating-my-real-infrastructure
    os.environ["AWS_ACCESS_KEY_ID"]     = "testing"
    os.environ["AWS_SECRET_ACCESS_KEY"] = "testing"
    os.environ["AWS_SECURITY_TOKEN"]    = "testing"
    os.environ["AWS_SESSION_TOKEN"]     = "testing"
    os.environ["AWS_DEFAULT_REGION"]    = "eu-west-2"

@mock_ec2
def test_revert_baseline_lambda_no_instances_to_patch():
    # setup: none
    # invoke lambda
    from critical_patching import revert_baseline_function # accept the moto mocked client, need __init__.py files for module reference
    assert revert_baseline_function.lambda_handler(event={"patch_group": "PatchGroup_1"}, context=None) == [] # no EC2s == nothing to do.

@mock_ec2
def test_revert_baseline_lambda_happy_path():
    # setup
    from critical_patching import revert_baseline_function # accept the moto mocked client, need __init__.py files for module reference
    instance_id: str = new_mocked_ec2_with_tags({ "Key": "PatchGroup", "Value": "CRITICAL_PatchGroup_1" })
    assert new_boto3_ec2_resource().Instance(instance_id).tags == [{"Key":"PatchGroup", "Value":"CRITICAL_PatchGroup_1"}]
    # invoke lambda, assert results
    assert revert_baseline_function.lambda_handler(event={"patch_group": "PatchGroup_1"}, context=None) == [instance_id] # found our EC2
    assert new_boto3_ec2_resource().Instance(instance_id).tags == [{"Key":"PatchGroup", "Value":"PatchGroup_1"}] # tags modified (remove CRITICAL prefix)

@mock_ec2
def test_revert_baseline_lambda_no_matching_ec2s():
    # setup
    from critical_patching import revert_baseline_function # accept the moto mocked client, need __init__.py files for module reference
    instance_id: str = new_mocked_ec2_with_tags({ "Key": "PatchGroup", "Value": "IMPORTANT_PatchGroup_1" })
    assert new_boto3_ec2_resource().Instance(instance_id).tags == [{"Key":"PatchGroup", "Value":"IMPORTANT_PatchGroup_1"}]
    # invoke lambda, assert results
    assert revert_baseline_function.lambda_handler(event={"patch_group": "PatchGroup_1"}, context=None) == [] # nothing done
    assert new_boto3_ec2_resource().Instance(instance_id).tags == [{"Key":"PatchGroup", "Value":"IMPORTANT_PatchGroup_1"}] # tags on unrelated EC2 instances unchanged
