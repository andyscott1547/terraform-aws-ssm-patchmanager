import os
import pytest
from moto import mock_ec2
from critical_patching.tests.ec2s_test_infra import new_boto3_ec2_resource, new_mocked_ec2_with_tags

@pytest.fixture
def mock_aws_environment(autouse=True): # TODO FIXME for reasons I don't understand, autouse=True doesn't seem to work? Therefore injected manually in each test
    # https://docs.getmoto.org/en/latest/docs/getting_started.html#how-do-i-avoid-tests-from-mutating-my-real-infrastructure
    os.environ["AWS_ACCESS_KEY_ID"]     = "testing"
    os.environ["AWS_SECRET_ACCESS_KEY"] = "testing"
    os.environ["AWS_SECURITY_TOKEN"]    = "testing"
    os.environ["AWS_SESSION_TOKEN"]     = "testing"
    os.environ["AWS_DEFAULT_REGION"]    = "eu-west-2"

@mock_ec2
def test_update_baseline_lambda_no_instances_to_patch(mock_aws_environment):
    # setup: none
    # invoke lambda
    from critical_patching import update_baseline_function # accept the moto mocked client, need __init__.py files for module reference
    assert update_baseline_function.lambda_handler(event={"patch_group": "PatchGroup_1"}, context=None) == [] # no EC2s == nothing to do.

@mock_ec2
def test_update_baseline_lambda_happy_path(mock_aws_environment):
    # setup
    from critical_patching import update_baseline_function # accept the moto mocked client, need __init__.py files for module reference
    instance_id: str = new_mocked_ec2_with_tags({ "Key": "PatchGroup", "Value": "PatchGroup_1" })
    assert new_boto3_ec2_resource().Instance(instance_id).tags == [{"Key":"PatchGroup", "Value":"PatchGroup_1"}]
    # invoke lambda, assert results
    assert update_baseline_function.lambda_handler(event={"patch_group": "PatchGroup_1"}, context=None) == [instance_id]
    assert new_boto3_ec2_resource().Instance(instance_id).tags == [{"Key":"PatchGroup", "Value":"CRITICAL_PatchGroup_1"}] # tags modified (add CRITICAL prefix)

@mock_ec2
def test_update_baseline_lambda_no_matching_ec2s(mock_aws_environment):
    # setup
    from critical_patching import update_baseline_function # accept the moto mocked client, need __init__.py files for module reference
    instance_id: str = new_mocked_ec2_with_tags({ "Key": "PatchGroup", "Value": "PatchGroup_22" })
    assert new_boto3_ec2_resource().Instance(instance_id).tags == [{"Key":"PatchGroup", "Value":"PatchGroup_22"}]
    # invoke lambda, assert results
    assert update_baseline_function.lambda_handler(event={"patch_group": "PatchGroup_1"}, context=None) == [] # basically nothing done
    assert new_boto3_ec2_resource().Instance(instance_id).tags == [{"Key":"PatchGroup", "Value":"PatchGroup_22"}] # tags on unrelated EC2 instance unchanged
